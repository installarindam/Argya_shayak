import 'package:ArogyaSahayak/passwordscreen.dart';
import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone, name, age, gender, address, pinCode;

  OtpVerificationScreen({
    required this.phone,
    required this.name,
    required this.age,
    required this.gender,
    required this.address,
    required this.pinCode,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _validateOtp() {
    if (_otpController.text == '232323') { // Replace with your OTP validation logic
      // Navigate to the password screen and pass the details
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordScreen(
            phone: widget.phone,
            name: widget.name,
            age: widget.age,
            gender: widget.gender,
            address: widget.address,
            pinCode: widget.pinCode,
          ),
        ),
      );
    } else {
      // Handle the error, such as showing an alert dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid OTP'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
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
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Text('OTP Verification', style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      hintText: 'Enter OTP',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _validateOtp,
                    child: Text('Verify'),
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
