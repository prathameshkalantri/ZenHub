import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> _signIn() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Sign in successful, navigate to next screen or do something else
    } catch (e) {
      print("Error during sign in: $e");
      // Handle errors here
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In',
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0, // Set the border width
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              obscureText: _isObscured,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 3.0, // Set the border width
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                  onPressed: _toggleObscure,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signIn,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan), // Button color
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TextButton(
              onPressed: _navigateToSignUp,
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color:Colors.cyan),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
