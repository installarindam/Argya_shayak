import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class FootCounter extends StatefulWidget {
  const FootCounter({Key? key}) : super(key: key);

  @override
  _FootCounterState createState() => _FootCounterState();
}

class _FootCounterState extends State<FootCounter> {
  double x = 0.0, y = 0.0, z = 0.0;
  double exactDistance = 0.0, previousDistance = 0.0;
  double goal = 10000; // Default goal
  TextEditingController goalController = TextEditingController();

  // Demo values
  List<Map<String, dynamic>> demoValues = [
    {'date': '11/08/2023', 'steps': 2000},
    {'date': '10/08/2023', 'steps': 3000},
  ];

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen(handleAccelerometerEvent);
  }

  void handleAccelerometerEvent(AccelerometerEvent event) {
    x = event.x;
    y = event.y;
    z = event.z;
    exactDistance = calculateMagnitude(x, y, z);
    if (exactDistance > 6) {
      setState(() {
        steps++;
      });
      setPrefData(steps); // Store steps to shared preferences
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1877F2),
      appBar: AppBar(
        title: Text("Step Counter"),
        backgroundColor: Color(0xFF1877F2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200, // Adjust as needed
                  height: 200, // Adjust as needed
                  child: CircularProgressIndicator(
                    value: steps / goal,
                    color: Colors.white,
                    strokeWidth: 10,
                  ),
                ),
                CircleAvatar(
                  radius: 94,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    steps.toString(),
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Set Target"),
                    content: TextField(
                      controller: goalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Enter Target"),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              goal = double.parse(goalController.text);
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Set Target"))
                    ],
                  )),
              child: Text("Set Target"),
            ),
            SizedBox(height: 20),
            Text(
              "Steps You Have Taken",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
            Text(
              "${(steps / goal * 100).toStringAsFixed(2)}% of goal reached",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20),
            Table(
              border: TableBorder.all(color: Colors.white),
              children: demoValues.map((row) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(row['date'], style: TextStyle(color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(row['steps'].toString(), style: TextStyle(color: Colors.white)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  double calculateMagnitude(double x, double y, double z) {
    double distance = sqrt(x * x + y * y + z * z);
    double mode = distance - previousDistance;
    previousDistance = distance; // Update the previous distance value
    return mode;
  }

  Future<void> setPrefData(int steps) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setInt("steps", steps);
  }

  Future<int> getPreviousValue() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getInt("steps") ?? 0;
  }
}
