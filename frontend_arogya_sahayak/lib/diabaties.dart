import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiabetesPredictionScreen extends StatefulWidget {
  @override
  _DiabetesPredictionScreenState createState() =>
      _DiabetesPredictionScreenState();
}

class _DiabetesPredictionScreenState extends State<DiabetesPredictionScreen> {
  final TextEditingController _pregnanciesController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _skinThicknessController = TextEditingController();
  final TextEditingController _insulinController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _diabetesPedigreeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _result = '';

  Future<void> submitForm() async {
    final response = await http.post(
      Uri.parse('http://20.192.10.30/predict_diabetes'),
      body: {
        'Pregnancies': _pregnanciesController.text,
        'Glucose': _glucoseController.text,
        'BloodPressure': _bloodPressureController.text,
        'SkinThickness': _skinThicknessController.text,
        'Insulin': _insulinController.text,
        'BMI': _bmiController.text,
        'DiabetesPedigreeFunction': _diabetesPedigreeController.text,
        'Age': _ageController.text,
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
        title: Text('Diabetes Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _pregnanciesController,
              decoration: InputDecoration(labelText: 'Number of Pregnancies:'),
            ),
            TextField(
              controller: _glucoseController,
              decoration: InputDecoration(labelText: 'Glucose Level:'),
            ),
            TextField(
              controller: _bloodPressureController,
              decoration: InputDecoration(labelText: 'Blood Pressure value:'),
            ),
            TextField(
              controller: _skinThicknessController,
              decoration: InputDecoration(labelText: 'Skin Thickness value:'),
            ),
            TextField(
              controller: _insulinController,
              decoration: InputDecoration(labelText: 'Insulin Level:'),
            ),
            TextField(
              controller: _bmiController,
              decoration: InputDecoration(labelText: 'BMI value:'),
            ),
            TextField(
              controller: _diabetesPedigreeController,
              decoration: InputDecoration(labelText: 'Diabetes Pedigree Function value:'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age of the Person:'),
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


