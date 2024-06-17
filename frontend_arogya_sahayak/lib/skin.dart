import 'package:ArogyaSahayak/skintest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SkinPage extends StatefulWidget {
  @override
  _SkinPageState createState() => _SkinPageState();
}

class _SkinPageState extends State<SkinPage> {
  final List<String> diseases = [
    "Acne & Rosacea",
    "Actinic Keratosis",
    "Atopic Dermatitis",
    "Bullous Disease",
    "Cellulitis & Impetigo",
    "Eczema",
    "Exanthems & Drug Eruptions",
    "Hair Loss & Alopecia",
    "Herpes & HPV",
    "Pigmentation Disorders",
    "Lupus & Connective Tissue Diseases",
    "Melanoma & Moles",
    "Nail Fungus",
    "Poison Ivy & Contact Dermatitis",
    "Psoriasis & Lichen Planus",
    "Scabies & Lyme Disease",
    "Seborrheic Keratoses",
    "Systemic Disease",
    "Tinea & Candidiasis",
    "Urticaria Hives",
    "Vascular Tumors",
    "VasculitisS",
    "Warts & Molluscum"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skin Diseases',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Alaktra',
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              "Our app supports detection of the following skin diseases:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Alaktra',
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: diseases.length,
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemBuilder: (context, index) {
                  return Text(
                    diseases[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Alaktra',
                      color: Colors.black.withOpacity(0.7),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SkinTest()),
                );
                // Navigate to test or camera capture screen
              },
              child: Text("Take Test", style: TextStyle(fontFamily: 'Alaktra')),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Note: Test results are AI-based and may not be 100% accurate. Always consult a professional.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12, fontFamily: 'Alaktra'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
