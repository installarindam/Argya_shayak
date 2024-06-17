import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'otp_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();
  String _selectedGender = 'Male'; // Default value
  String _phoneNumber = '';

  _next() {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _pinCodeController.text.isEmpty ||
        _phoneNumber.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please fill in all the fields."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(
          phone: _phoneNumber,
          name: _nameController.text,
          age: _ageController.text,
          gender: _selectedGender,
          address: _addressController.text,
          pinCode: _pinCodeController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c1733),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Image.asset(
              'assets/images/logo.jpg',
              height: 200,
              width: 200,
            ),
            Text('Arogya Shayak', style: TextStyle(fontSize: 24, color: Colors.white)),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Text('Creating Account', style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.blueAccent), // Set label c


                      hintText: '97xxxxxxxx',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      alignLabelWithHint: false,
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      _phoneNumber = phone.completeNumber;
                      print(_phoneNumber);
                    },
                  ),
                  //SizedBox(height: 10),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      hintText: 'Age',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _selectedGender,
                    items: <String>['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _pinCodeController,
                    decoration: InputDecoration(
                      hintText: 'Pin Code',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _next,
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff1E88E5),
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
