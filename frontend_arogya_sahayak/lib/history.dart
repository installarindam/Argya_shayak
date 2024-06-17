import 'dart:math';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> diseases = [
    'Thalassemia',
    'Heart Disease',
    'Diabetes',
    'Malaria',
    'Hypertension',
    'Asthma',
    'Tuberculosis',
    'Hepatitis B',
    'Hepatitis C',
    'Dengue Fever',
    'Chikungunya',
    'Pneumonia',
    'Arthritis',
    'Cancer',
    'Influenza',
    'Kidney Disease',
    'Liver Disease',
    'Peptic Ulcer',
    'Thyroid Disease',
    'Alzheimer’s Disease',
    'Parkinson’s Disease',
    'Multiple Sclerosis',
    'Osteoporosis',
    'Sickle Cell Anemia',
    'Polycystic Ovary Syndrome (PCOS)',
    'Celiac Disease',
    'Chronic Obstructive Pulmonary Disease (COPD)',
    'Crohn’s Disease',
    'Rheumatoid Arthritis',
    'Psoriasis',

  ];

  final List<String> medicines = [
    'Paracetamol',
    'Ibuprofen',
    'Aspirin',
    'Naproxen',
    'Amoxicillin',
    'Ciprofloxacin',
    'Levothyroxine',
    'Metformin',
    'Losartan',
    'Lisinopril',
    'Omeprazole',
    'Warfarin',
    'Simvastatin',
    'Atorvastatin',
    'Cetirizine',
    'Albuterol',
    'Hydrochlorothiazide',
    'Gabapentin',

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: 20,
        itemBuilder: (context, index) {
          if (index % 2 == 0) {
            final disease = diseases[Random().nextInt(diseases.length)];
            final result = Random().nextBool() ? 'Positive' : 'Negative';

            return _buildHistoryTile(
              category: 'Test',
              name: disease,
              result: result,
            );
          } else {
            final medicine = medicines[Random().nextInt(medicines.length)];
            final time = '${Random().nextInt(12) + 1} ${Random().nextBool() ? 'AM' : 'PM'}';

            return _buildHistoryTile(
              category: 'Med Reminder',
              name: medicine,
              result: time,
            );
          }
        },
      ),
    );
  }

  Widget _buildHistoryTile({
    required String category,
    required String name,
    required String result,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        leading: Icon(
          category == 'Test' ? Icons.science : Icons.medication,
          color: Colors.blue,
          size: 40,
        ),
        title: Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text(
              category,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(width: 10),
            Text(
              result,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
