import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeartDiseasePredictionScreen extends StatefulWidget {
  @override
  _HeartDiseasePredictionScreenState createState() =>
      _HeartDiseasePredictionScreenState();
}

class _HeartDiseasePredictionScreenState
    extends State<HeartDiseasePredictionScreen> {
  final TextEditingController _ageController = TextEditingController();
  String _selectedSex = '1'; // Default value for Female
  final TextEditingController _cpController = TextEditingController();
  final TextEditingController _trestbpsController = TextEditingController();
  final TextEditingController _cholController = TextEditingController();
  final TextEditingController _fbsController = TextEditingController();
  final TextEditingController _restecgController = TextEditingController();
  final TextEditingController _thalachController = TextEditingController();
  final TextEditingController _exangController = TextEditingController();
  final TextEditingController _oldpeakController = TextEditingController();
  final TextEditingController _slopeController = TextEditingController();
  final TextEditingController _caController = TextEditingController();
  final TextEditingController _thalController = TextEditingController();
  String _result = '';

  Future<void> submitForm() async {
    if (validateFields()) {
      final response = await http.post(
        Uri.parse('http://20.192.10.30/predict_heart'),
        body: {
          'age': _ageController.text,
          'sex': _selectedSex,
          'cp': _cpController.text,
          'trestbps': _trestbpsController.text,
          'chol': _cholController.text,
          'fbs': _fbsController.text,
          'restecg': _restecgController.text,
          'thalach': _thalachController.text,
          'exang': _exangController.text,
          'oldpeak': _oldpeakController.text,
          'slope': _slopeController.text,
          'ca': _caController.text,
          'thal': _thalController.text,
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
  }

  bool validateFields() {
    // You can add more specific validation rules as per the requirements.
    if (_ageController.text.isEmpty ||
        _cpController.text.isEmpty ||
        _trestbpsController.text.isEmpty ||
        _cholController.text.isEmpty ||
        _fbsController.text.isEmpty ||
        _restecgController.text.isEmpty ||
        _thalachController.text.isEmpty ||
        _exangController.text.isEmpty ||
        _oldpeakController.text.isEmpty ||
        _slopeController.text.isEmpty ||
        _caController.text.isEmpty ||
        _thalController.text.isEmpty) {
      setState(() {
        _result = 'Please fill all fields.';
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Disease Prediction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age:'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Gender:'),
              value: _selectedSex,
              items: [
                DropdownMenuItem<String>(value: '1', child: Text('Female')),
                DropdownMenuItem<String>(value: '0', child: Text('Male')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSex = newValue!;
                });
              },
            ),
            TextField(
              controller: _cpController,
              decoration: InputDecoration(labelText: 'Chest Pain Type:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _trestbpsController,
              decoration: InputDecoration(labelText: 'Resting Blood Pressure:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cholController,
              decoration: InputDecoration(labelText: 'Serum Cholesterol:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fbsController,
              decoration: InputDecoration(labelText: 'Fasting Blood Sugar:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _restecgController,
              decoration: InputDecoration(labelText: 'Resting ECG:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _thalachController,
              decoration: InputDecoration(labelText: 'Maximum Heart Rate:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _exangController,
              decoration: InputDecoration(labelText: 'Exercise Induced Angina:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _oldpeakController,
              decoration: InputDecoration(labelText: 'Old Peak:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _slopeController,
              decoration: InputDecoration(labelText: 'Slope:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _caController,
              decoration: InputDecoration(labelText: 'CA:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _thalController,
              decoration: InputDecoration(labelText: 'Thal:'),
              keyboardType: TextInputType.number,
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
