import 'package:ArogyaSahayak/periodtracker.dart';
import 'package:ArogyaSahayak/symptoms_analyser.dart';
import 'package:flutter/material.dart';

import 'medreminder.dart';

class InnerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Inner Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              title: 'Symptoms Analyzer',
              description: 'Analyze your symptoms with AI assistance. Get professional insights into your health.',
              color: Colors.purple[100]!,
              context: context,
              destinationScreen: SymptomAnalyzer(),
            ),
            SizedBox(height: 20),
            _buildCard(
              title: 'Periods Tracker',
              description: 'Keep track of your menstrual cycles. Receive predictions and statistics about your cycle.',
              color: Colors.pink[100]!,
              context: context,
              destinationScreen: PeriodTrackerPage(),
            ),
            SizedBox(height: 20),
            _buildCard(
              title: 'Med Reminder',
              description: 'Get reminders for your medications. Stay on top of your medication schedule and never miss a dose.',
              color: Colors.green[100]!,
              context: context,
              destinationScreen: MedReminderPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required Color color,
    required BuildContext context,
    required Widget destinationScreen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        color: color,
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.arrow_forward, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



