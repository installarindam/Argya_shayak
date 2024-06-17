import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class PeriodTrackerPage extends StatefulWidget {
  @override
  _PeriodTrackerPageState createState() => _PeriodTrackerPageState();
}

class _PeriodTrackerPageState extends State<PeriodTrackerPage> {
  List<DateTime> startDates = [];
  List<DateTime> endDates = [];
  int cycleLength = 28;
  String symptoms = "";
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isStartDate = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      startDates = (prefs.getStringList('startDates') ?? [])
          .map((e) => DateTime.parse(e))
          .toList();
      endDates = (prefs.getStringList('endDates') ?? [])
          .map((e) => DateTime.parse(e))
          .toList();
      cycleLength = prefs.getInt('cycleLength') ?? 28;
      symptoms = prefs.getString('symptoms') ?? "";
    });
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'startDates', startDates.map((e) => e.toIso8601String()).toList());
    prefs.setStringList(
        'endDates', endDates.map((e) => e.toIso8601String()).toList());
    prefs.setInt('cycleLength', cycleLength);
    prefs.setString('symptoms', symptoms);
  }

  _setReminder() async {
    // Notification logic here
  }

  Color getColorByMonth(DateTime date) {
    return Colors.primaries[date.month % Colors.primaries.length];
  }

  Map<String, List<DateTime>> groupDatesByMonth(List<DateTime> dates) {
    Map<String, List<DateTime>> groupedDates = {};
    for (DateTime date in dates) {
      String key = "${date.year}-${date.month}";
      if (groupedDates.containsKey(key)) {
        groupedDates[key]!.add(date);
      } else {
        groupedDates[key] = [date];
      }
    }
    return groupedDates;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<DateTime>> groupedStartDates = groupDatesByMonth(startDates);
    Map<String, List<DateTime>> groupedEndDates = groupDatesByMonth(endDates);

    return Scaffold(
      appBar: AppBar(
        title: Text('Period Tracker'),
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Toggle for Start and End Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => isStartDate = true),
                child: Text('Start Date'),
                style: ElevatedButton.styleFrom(
                  primary: isStartDate ? Colors.pink : Colors.grey,
                ),
              ),
              ElevatedButton(
                onPressed: () => setState(() => isStartDate = false),
                child: Text('End Date'),
                style: ElevatedButton.styleFrom(
                  primary: !isStartDate ? Colors.pink : Colors.grey,
                ),
              ),
            ],
          ),
          // Calendar View
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                if (isStartDate) {
                  startDates.add(selectedDay);
                } else {
                  endDates.add(selectedDay);
                }
                _saveData();
              });
            },
            eventLoader: (day) {
              return startDates.contains(day) || endDates.contains(day)
                  ? [day]
                  : [];
            },
          ),
          // Cycle Length Customization
          Slider(
            value: cycleLength.toDouble(),
            min: 21,
            max: 35,
            divisions: 14,
            label: cycleLength.toString(),
            onChanged: (double value) {
              setState(() {
                cycleLength = value.toInt();
                _saveData();
              });
            },
          ),
          // Symptom Tracking
          TextField(
            controller: TextEditingController(text: symptoms),
            decoration: InputDecoration(labelText: 'Symptoms'),
            onChanged: (value) {
              symptoms = value;
              _saveData();
            },
          ),
          // Notifications
          ElevatedButton(
            onPressed: _setReminder,
            child: Text('Set Reminder'),
          ),
          // History
          Text('History:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...groupedStartDates.keys.map((key) {
            List<DateTime> starts = groupedStartDates[key]!;
            List<DateTime> ends = groupedEndDates[key] ?? [];
            return Card(
              color: getColorByMonth(starts[0]),
              child: ListTile(
                title: Text('Month: ${starts[0].month}, Year: ${starts[0].year}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...starts.map((date) => Text('Start: $date')),
                    ...ends.map((date) => Text('End: $date')),
                  ],
                ),
              ),
            );
          }),
          // More statistics and UI components can be added here
        ],
      ),
    );
  }
}
