import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LiverDiseasePredictionScreen extends StatefulWidget {
  @override
  _LiverDiseasePredictionScreenState createState() =>
      _LiverDiseasePredictionScreenState();
}

class _LiverDiseasePredictionScreenState
    extends State<LiverDiseasePredictionScreen> {
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = '1'; // Default value
  final TextEditingController _totalBilirubinController = TextEditingController();
  final TextEditingController _directBilirubinController = TextEditingController();
  final TextEditingController _alkalinePhosphotaseController = TextEditingController();
  final TextEditingController _alamineAminotransferaseController = TextEditingController();
  final TextEditingController _aspartateAminotransferaseController = TextEditingController();
  final TextEditingController _totalProteinsController = TextEditingController();
  final TextEditingController _albuminController = TextEditingController();
  final TextEditingController _albuminAndGlobulinRatioController = TextEditingController();
  String _result = '';

  Future<void> submitForm() async {
    final response = await http.post(
      Uri.parse('http://20.192.10.30/predict_liver'),
      body: {
        'Age': _ageController.text,
        'Gender': _selectedGender,
        'Total_Bilirubin': _totalBilirubinController.text,
        'Direct_Bilirubin': _directBilirubinController.text,
        'Alkaline_Phosphotase': _alkalinePhosphotaseController.text,
        'Alamine_Aminotransferase': _alamineAminotransferaseController.text,
        'Aspartate_Aminotransferase': _aspartateAminotransferaseController.text,
        'Total_Proteins': _totalProteinsController.text,
        'Albumin': _albuminController.text,
        'Albumin_and_Globulin_Ratio': _albuminAndGlobulinRatioController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];
      setState(() {
        _result = result;
      });
    } else {
      setState(() {
        _result = 'Error predicting.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liver Disease Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age:'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: ['1', '0'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == '1' ? 'Male' : 'Female'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Gender:'),
            ),
            TextField(
              controller: _totalBilirubinController,
              decoration: InputDecoration(labelText: 'Total Bilirubin:'),
            ),
            TextField(
              controller: _directBilirubinController,
              decoration: InputDecoration(labelText: 'Direct Bilirubin:'),
            ),
            TextField(
              controller: _alkalinePhosphotaseController,
              decoration: InputDecoration(labelText: 'Alkaline Phosphotase:'),
            ),
            TextField(
              controller: _alamineAminotransferaseController,
              decoration: InputDecoration(labelText: 'Alamine Aminotransferase:'),
            ),
            TextField(
              controller: _aspartateAminotransferaseController,
              decoration: InputDecoration(labelText: 'Aspartate Aminotransferase:'),
            ),
            TextField(
              controller: _totalProteinsController,
              decoration: InputDecoration(labelText: 'Total Proteins:'),
            ),
            TextField(
              controller: _albuminController,
              decoration: InputDecoration(labelText: 'Albumin:'),
            ),
            TextField(
              controller: _albuminAndGlobulinRatioController,
              decoration: InputDecoration(labelText: 'Albumin and Globulin Ratio:'),
            ),
            ElevatedButton(
              onPressed: submitForm,
              child: Text('Predict'),
            ),
            SizedBox(height: 20),
            Text(
              'Prediction: $_result',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}


