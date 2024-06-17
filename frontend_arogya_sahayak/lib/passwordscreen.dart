import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'main.dart'; // Import your login screen here

class PasswordScreen extends StatefulWidget {
  final String phone, name, age, gender, address, pinCode;

  PasswordScreen({
    required this.phone,
    required this.name,
    required this.age,
    required this.gender,
    required this.address,
    required this.pinCode,
  });

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  Future<void> _submitPassword() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      setState(() {
        _isLoading = true;
      });
      await pushDataToSupabase();
      setState(() {
        _isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Passwords do not match.'),
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

  Future<void> pushDataToSupabase() async {
    try {
      String phone = widget.phone.length == 13 ? widget.phone.substring(3) : widget.phone;
      await supabase.from('masterdata').insert([
        {
          'id': phone,
          'name': widget.name,
          'age': widget.age,
          'gender': widget.gender,
          'address': widget.address,
          'postalcode': widget.pinCode,
        },
      ]).execute();

      await supabase.from('credentials').insert([
        {
          'id': phone,
          'password': _confirmPasswordController.text,
        },
      ]).execute();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Password set successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff0c1733),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset(
                'assets/images/logo.jpg',
                height: 200,
                width: 200,
              ),
              Text("Arogya Sahayak", style: TextStyle(fontSize: 24, color: Colors.white)),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordHidden ? Icons.visibility : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _isPasswordHidden,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordHidden ? Icons.visibility : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _isPasswordHidden,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitPassword,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff1E88E5),
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
