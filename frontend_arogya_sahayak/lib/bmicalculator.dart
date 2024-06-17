import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  double? bmi;
  String? bmiCategory;
  String? bmiGuidance;
  Color? bmiColor;

  void calculateBMI() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100; // Assuming height in cm
    double bmiValue = weight / (height * height);

    String category;
    String guidance;
    Color color;

    if (bmiValue < 18.5) {
      category = "Underweight";
      guidance = "You may need to gain some weight. Consult with a healthcare provider for personalized advice.";
      color = Colors.yellow;
    } else if (bmiValue < 24.9) {
      category = "Normal weight";
      guidance = "You are in a healthy weight range. Keep up the good work!";
      color = Colors.green;
    } else if (bmiValue < 29.9) {
      category = "Overweight";
      guidance = "You may need to lose some weight. Consult with a healthcare provider for personalized advice.";
      color = Colors.yellow;
    } else {
      category = "Obesity";
      guidance = "You may need to lose significant weight. Consult with a healthcare provider for personalized advice.";
      color = Colors.red;
    }

    setState(() {
      bmi = bmiValue;
      bmiCategory = category;
      bmiGuidance = guidance;
      bmiColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Weight (kg)"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Height (cm)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateBMI,
              child: Text("Calculate BMI"),
            ),
            SizedBox(height: 20),
            bmi != null
                ? Column(
              children: [
                Text(
                  "Your BMI: ${bmi!.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Category: $bmiCategory",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bmiColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    bmiGuidance!,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
