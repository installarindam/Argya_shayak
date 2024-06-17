import 'package:ArogyaSahayak/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_data.dart'; // Import the AppData class
import 'package:ArogyaSahayak/dashboard_screen.dart'; // Replace with the actual dashboard screen
import 'main.dart';

var id = '';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _passwordVisible = false;

  String welcomeText = 'Arogya Sahayak';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedId = prefs.getString('id') ?? '';
    String savedPassword = prefs.getString('password') ?? '';
    bool savedRememberMe = prefs.getBool('rememberMe') ?? false;

    setState(() {
      _idController.text = savedId;
      _passwordController.text = savedPassword;
      _rememberMe = savedRememberMe;
      if (savedId.isNotEmpty && savedPassword.isNotEmpty) {
        welcomeText = 'Welcome Back';
      }
      if (savedId.isEmpty && savedPassword.isEmpty) {
        welcomeText = 'Arogya Sahayak';
      }
    });
  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_rememberMe) {
      prefs.setString('id', _idController.text);
      prefs.setString('password', _passwordController.text);
    } else {
      prefs.remove('id');
      prefs.remove('password');
    }

    prefs.setBool('rememberMe', _rememberMe);
  }

  _login() async {
    String enteredId = _idController.text;
    String enteredPassword = _passwordController.text;

    final response = await supabase.from('credentials').select().eq('id', enteredId).eq('role', 'user').execute();
    final credentialsData = response.data;

    if (credentialsData.isNotEmpty) {
      String storedPassword = credentialsData[0]['password'];

      if (enteredPassword == storedPassword) {
        id = enteredId;
        _saveCredentials();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        _showLoginErrorDialog('Invalid credentials. Please try again.');
      }
    } else {
      _showLoginErrorDialog('User with the entered ID does not exist. Please sign up.');
    }

    if (!_rememberMe) {
      _idController.clear();
      _passwordController.clear();
      _saveCredentials();
    }
  }

  _showLoginErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
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
            SizedBox(height: 20),
            Text(
              welcomeText,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  TextField(
                    controller: _idController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    obscureText: !_passwordVisible,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _rememberMe,
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text('Remember Me', style: TextStyle(color: Colors.white)),
              ],
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff1E88E5),
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text('Forgot Password?', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
