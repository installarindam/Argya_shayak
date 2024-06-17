import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BreastCancerPredictionScreen extends StatefulWidget {
  @override
  _BreastCancerPredictionScreenState createState() =>
      _BreastCancerPredictionScreenState();
}

class _BreastCancerPredictionScreenState
    extends State<BreastCancerPredictionScreen> {
  // Controllers
  final TextEditingController _radiusMeanController = TextEditingController();
  final TextEditingController _textureMeanController = TextEditingController();
  final TextEditingController _perimeterMeanController = TextEditingController();
  final TextEditingController _areaMeanController = TextEditingController();
  final TextEditingController _smoothnessMeanController = TextEditingController();
  final TextEditingController _compactnessMeanController = TextEditingController();
  final TextEditingController _concavityMeanController = TextEditingController();
  final TextEditingController _concavePointsMeanController = TextEditingController();
  final TextEditingController _symmetryMeanController = TextEditingController();
  final TextEditingController _fractalDimensionMeanController = TextEditingController();
  final TextEditingController _radiusSEController = TextEditingController();
  final TextEditingController _textureSEController = TextEditingController();
  final TextEditingController _perimeterSEController = TextEditingController();
  final TextEditingController _areaSEController = TextEditingController();
  final TextEditingController _smoothnessSEController = TextEditingController();
  final TextEditingController _compactnessSEController = TextEditingController();
  final TextEditingController _concavitySEController = TextEditingController();
  final TextEditingController _concavePointsSEController = TextEditingController();
  final TextEditingController _symmetrySEController = TextEditingController();
  final TextEditingController _fractalDimensionSEController = TextEditingController();
  final TextEditingController _radiusWorstController = TextEditingController();
  final TextEditingController _textureWorstController = TextEditingController();
  final TextEditingController _perimeterWorstController = TextEditingController();
  final TextEditingController _areaWorstController = TextEditingController();
  final TextEditingController _smoothnessWorstController = TextEditingController();
  final TextEditingController _compactnessWorstController = TextEditingController();
  final TextEditingController _concavityWorstController = TextEditingController();
  final TextEditingController _concavePointsWorstController = TextEditingController();
  final TextEditingController _symmetryWorstController = TextEditingController();
  final TextEditingController _fractalDimensionWorstController = TextEditingController();
  String _result = '';

  // Submit Form Function
  Future<void> submitForm() async {
    final response = await http.post(
      Uri.parse('http://20.192.10.30/breast_cancer'),
      body: {
        'radius_mean': _radiusMeanController.text,
        'texture_mean': _textureMeanController.text,
        'perimeter_mean': _perimeterMeanController.text,
        'area_mean': _areaMeanController.text,
        'smoothness_mean': _smoothnessMeanController.text,
        'compactness_mean': _compactnessMeanController.text,
        'concavity_mean': _concavityMeanController.text,
        'concave points_mean': _concavePointsMeanController.text,
        'symmetry_mean': _symmetryMeanController.text,
        'fractal_dimension_mean': _fractalDimensionMeanController.text,
        'radius_se': _radiusSEController.text,
        'texture_se': _textureSEController.text,
        'perimeter_se': _perimeterSEController.text,
        'area_se': _areaSEController.text,
        'smoothness_se': _smoothnessSEController.text,
        'compactness_se': _compactnessSEController.text,
        'concavity_se': _concavitySEController.text,
        'concave points_se': _concavePointsSEController.text,
        'symmetry_se': _symmetrySEController.text,
        'fractal_dimension_se': _fractalDimensionSEController.text,
        'radius_worst': _radiusWorstController.text,
        'texture_worst': _textureWorstController.text,
        'perimeter_worst': _perimeterWorstController.text,
        'area_worst': _areaWorstController.text,
        'smoothness_worst': _smoothnessWorstController.text,
        'compactness_worst': _compactnessWorstController.text,
        'concavity_worst': _concavityWorstController.text,
        'concave points_worst': _concavePointsWorstController.text,
        'symmetry_worst': _symmetryWorstController.text,
        'fractal_dimension_worst': _fractalDimensionWorstController.text,
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
        title: Text('Breast Cancer Prediction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _radiusMeanController,
              decoration: InputDecoration(labelText: 'Radius Mean:'),
            ),
            TextField(
              controller: _textureMeanController,
              decoration: InputDecoration(labelText: 'Texture Mean:'),
            ),
            TextField(
              controller: _perimeterMeanController,
              decoration: InputDecoration(labelText: 'Perimeter Mean:'),
            ),
            TextField(
              controller: _areaMeanController,
              decoration: InputDecoration(labelText: 'Area Mean:'),
            ),
            TextField(
              controller: _smoothnessMeanController,
              decoration: InputDecoration(labelText: 'Smoothness Mean:'),
            ),
            TextField(
              controller: _compactnessMeanController,
              decoration: InputDecoration(labelText: 'Compactness Mean:'),
            ),
            TextField(
              controller: _concavityMeanController,
              decoration: InputDecoration(labelText: 'Concavity Mean:'),
            ),
            TextField(
              controller: _concavePointsMeanController,
              decoration: InputDecoration(labelText: 'Concave Points Mean:'),
            ),
            TextField(
              controller: _symmetryMeanController,
              decoration: InputDecoration(labelText: 'Symmetry Mean:'),
            ),
            TextField(
              controller: _fractalDimensionMeanController,
              decoration: InputDecoration(labelText: 'Fractal Dimension Mean:'),
            ),
            TextField(
              controller: _radiusSEController,
              decoration: InputDecoration(labelText: 'Radius SE:'),
            ),
            TextField(
              controller: _textureSEController,
              decoration: InputDecoration(labelText: 'Texture SE:'),
            ),
            TextField(
              controller: _perimeterSEController,
              decoration: InputDecoration(labelText: 'Perimeter SE:'),
            ),
            TextField(
              controller: _areaSEController,
              decoration: InputDecoration(labelText: 'Area SE:'),
            ),
            TextField(
              controller: _smoothnessSEController,
              decoration: InputDecoration(labelText: 'Smoothness SE:'),
            ),
            TextField(
              controller: _compactnessSEController,
              decoration: InputDecoration(labelText: 'Compactness SE:'),
            ),
            TextField(
              controller: _concavitySEController,
              decoration: InputDecoration(labelText: 'Concavity SE:'),
            ),
            TextField(
              controller: _concavePointsSEController,
              decoration: InputDecoration(labelText: 'Concave Points SE:'),
            ),
            TextField(
              controller: _symmetrySEController,
              decoration: InputDecoration(labelText: 'Symmetry SE:'),
            ),
            TextField(
              controller: _fractalDimensionSEController,
              decoration: InputDecoration(labelText: 'Fractal Dimension SE:'),
            ),
            TextField(
              controller: _radiusWorstController,
              decoration: InputDecoration(labelText: 'Radius Worst:'),
            ),
            TextField(
              controller: _textureWorstController,
              decoration: InputDecoration(labelText: 'Texture Worst:'),
            ),
            TextField(
              controller: _perimeterWorstController,
              decoration: InputDecoration(labelText: 'Perimeter Worst:'),
            ),
            TextField(
              controller: _areaWorstController,
              decoration: InputDecoration(labelText: 'Area Worst:'),
            ),
            TextField(
              controller: _smoothnessWorstController,
              decoration: InputDecoration(labelText: 'Smoothness Worst:'),
            ),
            TextField(
              controller: _compactnessWorstController,
              decoration: InputDecoration(labelText: 'Compactness Worst:'),
            ),
            TextField(
              controller: _concavityWorstController,
              decoration: InputDecoration(labelText: 'Concavity Worst:'),
            ),
            TextField(
              controller: _concavePointsWorstController,
              decoration: InputDecoration(labelText: 'Concave Points Worst:'),
            ),
            TextField(
              controller: _symmetryWorstController,
              decoration: InputDecoration(labelText: 'Symmetry Worst:'),
            ),
            TextField(
              controller: _fractalDimensionWorstController,
              decoration: InputDecoration(labelText: 'Fractal Dimension Worst:'),
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
