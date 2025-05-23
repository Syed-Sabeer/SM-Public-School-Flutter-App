import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../main/children_view.dart'; // Import your ChildrenView page

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase instance
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // For showing loading state

  // Sign-in function
  Future<void> _signIn(BuildContext context) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog("Please enter both username and password.");
      return;
    }

    final email = "$username@school.com"; // Append "@school.com"

    setState(() {
      _isLoading = true;
    });

    try {
      // Authenticate with Firebase
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Redirect to ChildrenView on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChildrenView()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message ?? "Login failed. Please try again.";
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFBFF5D8), // Light green
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100.0),
                      bottomRight: Radius.circular(100.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              // Title
              const Text(
                "Let's Sign in",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                "SM Public School",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40.0),
              // Username Input
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "Username (e.g., 4240112345678)",
                  prefixIcon: const Icon(Icons.person, color: Colors.black54),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                  suffixIcon: const Icon(Icons.visibility_off, color: Colors.black54),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _signIn(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002D62), // Deep blue
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30.0),
              // Terms and Conditions
              const Center(
                child: Text(
                  "By logging in, you agree to our\nTerms & Condition & Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
