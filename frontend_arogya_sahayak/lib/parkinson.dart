import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ParkinsonsDiseasePredictionScreen extends StatefulWidget {
  @override
  _ParkinsonsDiseasePredictionScreenState createState() =>
      _ParkinsonsDiseasePredictionScreenState();
}

class _ParkinsonsDiseasePredictionScreenState
    extends State<ParkinsonsDiseasePredictionScreen> {
  final TextEditingController _foController = TextEditingController();
  final TextEditingController _fhiController = TextEditingController();
  final TextEditingController _floController = TextEditingController();
  final TextEditingController _jitterPercentController = TextEditingController();
  final TextEditingController _jitterAbsController = TextEditingController();
  final TextEditingController _rapController = TextEditingController();
  final TextEditingController _ppqController = TextEditingController();
  final TextEditingController _ddpController = TextEditingController();
  final TextEditingController _shimmerController = TextEditingController();
  final TextEditingController _shimmerdBController = TextEditingController();
  final TextEditingController _apq3Controller = TextEditingController();
  final TextEditingController _apq5Controller = TextEditingController();
  final TextEditingController _apqController = TextEditingController();
  final TextEditingController _ddaController = TextEditingController();
  final TextEditingController _nhrController = TextEditingController();
  final TextEditingController _hnrController = TextEditingController();
  final TextEditingController _rpdeController = TextEditingController();
  final TextEditingController _dfaController = TextEditingController();
  final TextEditingController _spread1Controller = TextEditingController();
  final TextEditingController _spread2Controller = TextEditingController();
  final TextEditingController _d2Controller = TextEditingController();
  final TextEditingController _ppeController = TextEditingController();
  String _result = '';

  Future<void> submitForm() async {
    if (!_validateInputs()) return;

    final response = await http.post(
      Uri.parse('http://20.192.10.30/predict_parkinsons'),
      body: {
        'fo': _foController.text,
        'fhi': _fhiController.text,
        'flo': _floController.text,
        'Jitter_percent': _jitterPercentController.text,
        'Jitter_Abs': _jitterAbsController.text,
        'RAP': _rapController.text,
        'PPQ': _ppqController.text,
        'DDP': _ddpController.text,
        'Shimmer': _shimmerController.text,
        'Shimmer_dB': _shimmerdBController.text,
        'APQ3': _apq3Controller.text,
        'APQ5': _apq5Controller.text,
        'APQ': _apqController.text,
        'DDA': _ddaController.text,
        'NHR': _nhrController.text,
        'HNR': _hnrController.text,
        'RPDE': _rpdeController.text,
        'DFA': _dfaController.text,
        'spread1': _spread1Controller.text,
        'spread2': _spread2Controller.text,
        'D2': _d2Controller.text,
        'PPE': _ppeController.text,
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

  bool _validateInputs() {
    bool isValid = true;
    List<TextEditingController> controllers = [
      _foController,
      _fhiController,
      _floController,
      _jitterPercentController,
      _jitterAbsController,
      _rapController,
      _ppqController,
      _ddpController,
      _shimmerController,
      _shimmerdBController,
      _apq3Controller,
      _apq5Controller,
      _apqController,
      _ddaController,
      _nhrController,
      _hnrController,
      _rpdeController,
      _dfaController,
      _spread1Controller,
      _spread2Controller,
      _d2Controller,
      _ppeController,
    ];

    for (var controller in controllers) {
      if (controller.text.isEmpty || double.tryParse(controller.text) == null) {
        isValid = false;
        controller.clear();
      }
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields correctly.')),
      );
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parkinson's Disease Prediction"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _foController,
              decoration: InputDecoration(
                  labelText: 'Fundamental Frequency (fo):'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fhiController,
              decoration: InputDecoration(labelText: 'High Frequency (fhi):'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _floController,
              decoration: InputDecoration(labelText: 'Low Frequency (flo):'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _jitterPercentController,
              decoration: InputDecoration(labelText: 'Jitter Percent:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _jitterAbsController,
              decoration: InputDecoration(labelText: 'Jitter Absolute:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _rapController,
              decoration: InputDecoration(labelText: 'RAP:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _ppqController,
              decoration: InputDecoration(labelText: 'PPQ:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _ddpController,
              decoration: InputDecoration(labelText: 'DDP:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _shimmerController,
              decoration: InputDecoration(labelText: 'Shimmer:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _shimmerdBController,
              decoration: InputDecoration(labelText: 'Shimmer dB:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _apq3Controller,
              decoration: InputDecoration(labelText: 'APQ3:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _apq5Controller,
              decoration: InputDecoration(labelText: 'APQ5:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _apqController,
              decoration: InputDecoration(labelText: 'APQ:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _ddaController,
              decoration: InputDecoration(labelText: 'DDA:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _nhrController,
              decoration: InputDecoration(labelText: 'NHR:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _hnrController,
              decoration: InputDecoration(labelText: 'HNR:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _rpdeController,
              decoration: InputDecoration(labelText: 'RPDE:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dfaController,
              decoration: InputDecoration(labelText: 'DFA:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _spread1Controller,
              decoration: InputDecoration(labelText: 'Spread1:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _spread2Controller,
              decoration: InputDecoration(labelText: 'Spread2:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _d2Controller,
              decoration: InputDecoration(labelText: 'D2:'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _ppeController,
              decoration: InputDecoration(labelText: 'PPE:'),
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

void main() => runApp(MaterialApp(home: ParkinsonsDiseasePredictionScreen()));
