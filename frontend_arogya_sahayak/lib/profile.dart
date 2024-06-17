import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScreenshotController screenshotController = ScreenshotController();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _allergiesController = TextEditingController();
  TextEditingController _diabetesController = TextEditingController();
  TextEditingController _pressureController = TextEditingController();
  TextEditingController _customFieldController = TextEditingController();
  TextEditingController _customValueController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _saveProfile();
      }
    });


  }

  _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? "";
    _ageController.text = prefs.getString('age') ?? "";
    _genderController.text = prefs.getString('gender') ?? "";
    _bloodGroupController.text = prefs.getString('blood_group') ?? "";
    _allergiesController.text = prefs.getString('allergies') ?? "";
    _diabetesController.text = prefs.getString('diabetes') ?? "";
    _pressureController.text = prefs.getString('pressure') ?? "";
    _customFieldController.text = prefs.getString('custom_field') ?? "";
    _customValueController.text = prefs.getString('custom_value') ?? "";
    _statusController.text = prefs.getString('status') ?? "";
  }

  _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setString('age', _ageController.text);
    prefs.setString('gender', _genderController.text);
    prefs.setString('blood_group', _bloodGroupController.text);
    prefs.setString('allergies', _allergiesController.text);
    prefs.setString('diabetes', _diabetesController.text);
    prefs.setString('pressure', _pressureController.text);
    prefs.setString('custom_field', _customFieldController.text);
    prefs.setString('custom_value', _customValueController.text);
    prefs.setString('status', _statusController.text);
  }

  Future<void> _shareImage() async {
    final capturedImage = await screenshotController.capture();
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/image.jpg';
    final file = File(imagePath);
    await file.writeAsBytes(capturedImage!);

    final xFile = XFile(imagePath);

    final result = await Share.shareXFiles([xFile], text: 'Hey,This is my Medical Report form Arogya Sahayak App');

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the picture!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Arogya Sahayak',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
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
          actions: [
            _isEditMode
                ? IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                setState(() {
                  _isEditMode = false;
                  _saveProfile();
                });
              },
            )
                : IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                _shareImage();
              },
            ),
            IconButton(
              icon: Icon(_isEditMode ? Icons.close : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditMode = !_isEditMode;
                  if (!_isEditMode) {
                    _saveProfile();
                  }
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 7),
                ),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      'https://static.vecteezy.com/system/resources/previews/014/194/232/original/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg'),
                ),
              ),
              SizedBox(height: 20),
              _isEditMode ? _buildEditMode() : _buildViewMode(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditMode() {
    return Column(
      children: [
        _buildTextField(_nameController, "Name"),
        _buildTextField(_ageController, "Age"),
        _buildTextField(_genderController, "Gender"),
        _buildTextField(_bloodGroupController, "Blood Group"),
        _buildTextField(_allergiesController, "Allergies"),
        _buildTextField(_diabetesController, "Diabetes"),
        _buildTextField(_pressureController, "Blood Pressure"),
        _buildTextField(_statusController, "Current Status"),
        _buildTextField(_customFieldController, "Custom Field Name"),
        _buildTextField(_customValueController, "Custom Field Value"),
      ],
    );
  }

  Widget _buildViewMode() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/prescription_background.png'),
        // Background image resembling a prescription paper
        Positioned(
          top: 100,
          left: 20,
          child: Padding( // Adding padding here
            padding: const EdgeInsets.only(left: 20.0),
            // Additional padding to the left
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildViewField("Name", _nameController.text),
                _buildViewField("Age", _ageController.text),
                _buildViewField("Gender", _genderController.text),
                _buildViewField("Blood Group", _bloodGroupController.text),
                _buildViewField("Allergies", _allergiesController.text),
                _buildViewField("Diabetes", _diabetesController.text),
                _buildViewField("Blood Pressure", _pressureController.text),
                _buildViewField("Current Status", _statusController.text),
                _buildViewField(
                    "Custom Field Name", _customFieldController.text),
                _buildViewField(
                    "Custom Field Value", _customValueController.text),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 14, // Made the text a little smaller
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: !_isEditMode,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

}
