import 'package:flutter/material.dart';
import 'package:ArogyaSahayak/dashboard_screen.dart';
import 'package:ArogyaSahayak/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashScreen extends StatefulWidget {
  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoggedInUser();
  }

  void checkLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user is already logged in by fetching the status from Shared Preferences
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // After checking, navigate to the appropriate screen
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c1733),
      body: Center(
        child: Image.asset(
          'assets/images/logo.jpg',
          width: 300, // Adjust the width to make the logo bigger
          height: 300, // Adjust the height to make the logo bigger
        ),
      ),
    );
  }
}
