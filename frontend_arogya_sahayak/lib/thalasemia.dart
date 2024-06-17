import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThalasemiaPredictionScreen extends StatefulWidget {
  @override
  _ThalasemiaPredictionScreenState createState() =>
      _ThalasemiaPredictionScreenState();
}

class _ThalasemiaPredictionScreenState
    extends State<ThalasemiaPredictionScreen> {
  final TextEditingController _ageController = TextEditingController();
  String _selectedSex = 'Male'; // Default value
  final TextEditingController _hbController = TextEditingController();
  final TextEditingController _hctController = TextEditingController();
  final TextEditingController _mcvController = TextEditingController();
  final TextEditingController _mchController = TextEditingController();
  final TextEditingController _mchcController = TextEditingController();
  final TextEditingController _rdwController = TextEditingController();
  final TextEditingController _rbcCountController = TextEditingController();
  bool _isLoading = false;

  Future<void> submitForm() async {
    if (_ageController.text.isEmpty ||
        _hbController.text.isEmpty ||
        _hctController.text.isEmpty ||
        _mcvController.text.isEmpty ||
        _mchController.text.isEmpty ||
        _mchcController.text.isEmpty ||
        _rdwController.text.isEmpty ||
        _rbcCountController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please fill in all the fields."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final sexValue = _selectedSex == 'Male' ? '2' : '1';
    final response = await http.post(
      Uri.parse('http://20.192.10.30/thalasemia'),
      body: {
        'Age': _ageController.text,
        'Sex 1: female / 2: male': sexValue,
        'Hb': _hbController.text,
        'Hct': _hctController.text,
        'MCV': _mcvController.text,
        'MCH': _mchController.text,
        'MCHC': _mchcController.text,
        'RDW': _rdwController.text,
        'RBC count': _rbcCountController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor:
          result == "Thalasemia positive" ? Colors.red[100] : Colors.green[100],
          title: Text(
            result == "Thalasemia positive" ? "Danger" : "Safe",
            style: TextStyle(color: result == "Thalasemia positive" ? Colors.red : Colors.green),
          ),
          content: Text(
            result == "Thalasemia positive" ? "Thalasemia Positive" : "Thalasemia Negative",
            style: TextStyle(color: result == "Thalasemia positive" ? Colors.red : Colors.green),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thalasemia Prediction'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField('Age:', 'Example: 21', _ageController),
            _buildDropdownButton(),
            _buildTextField('Hb:', 'Example: 18', _hbController),
            _buildTextField('Hct:', 'Example: 40', _hctController),
            _buildTextField('MCV:', 'Example: 6', _mcvController),
            _buildTextField('MCH:', 'Example: 29', _mchController),
            _buildTextField('MCHC:', 'Example: 34', _mchcController),
            _buildTextField('RDW:', 'Example: 14', _rdwController),
            _buildTextField('RBC count:', 'Example: 5', _rbcCountController),
            ElevatedButton(
              onPressed: submitForm,
              child: Text('Predict'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                elevation: 5.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Sex:',
          border: OutlineInputBorder(),
        ),
        value: _selectedSex,
        items: ['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSex = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildTextField(
      String label, String placeholder, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),


      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
