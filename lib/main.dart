import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package
// Import Home View
import './auth/signin.dart'; // Import Sign In View

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures proper initialization of bindings for async operations
  await Firebase.initializeApp(); // Initialize Firebase services
  runApp(const MyApp()); // Run the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      title: 'SM Public School', // App title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Set theme color
        useMaterial3: true, // Enable Material 3 design
      ),
      home: SignInView(), // Initial screen set to SignInView
    );
  }
}
