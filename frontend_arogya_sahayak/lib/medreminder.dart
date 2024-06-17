import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Import your main.dart to access flutterLocalNotificationsPlugin

class MedReminderPage extends StatefulWidget {
  @override
  _MedReminderPageState createState() => _MedReminderPageState();
}

class _MedReminderPageState extends State<MedReminderPage> {
  TextEditingController medicationController = TextEditingController();
  DateTime selectedTime = DateTime.now();
  bool repeatDaily = false;
  List<String> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  _loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      reminders = prefs.getStringList('reminders') ?? [];
    });
  }

  Future<void> _setReminder() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'med_reminder',
      'Medicine Reminder',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('med_remind'), // Custom sound
    );

    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    int notificationId = Random().nextInt(1000000); // Unique ID for the notification

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Medicine Reminder',
      'Time to take ${medicationController.text}',
      tz.TZDateTime.from(selectedTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null, // Repeat daily if selected
    );

    // Store the reminder locally
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reminders.add('${medicationController.text} at ${selectedTime.toLocal()}');
    prefs.setStringList('reminders', reminders);

    Fluttertoast.showToast(
      msg: "Reminder set successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    _loadReminders(); // Refresh the reminders list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Reminder'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: medicationController,
              decoration: InputDecoration(
                labelText: "Medication Name",
                hintText: "Enter Medication Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.medical_services),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                final TimeOfDay? timePicked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selectedTime),
                );
                if (picked != null && timePicked != null) {
                  setState(() {
                    selectedTime = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      timePicked.hour,
                      timePicked.minute,
                    );
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Time",
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.access_time),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: repeatDaily,
                  onChanged: (value) {
                    setState(() {
                      repeatDaily = value!;
                    });
                  },
                ),
                Text("Repeat daily"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setReminder,
              child: Text(
                "Set Reminder",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Reminders:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...reminders.map((reminder) => ListTile(title: Text(reminder))),
          ],
        ),
      ),
    );
  }
}
