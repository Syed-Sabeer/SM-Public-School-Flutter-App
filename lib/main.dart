import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import './auth/signin.dart'; 
import './main/children_view.dart'; 
import './main/controller/auth_controller.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SM Public School',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthStreamBuilder(), // Use a stream builder to listen for authentication state
    );
  }
}

class AuthStreamBuilder extends StatelessWidget {
  const AuthStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthController().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return const ChildrenView(); // Redirect to ChildrenView when logged in
        } else {
          return const SignInView(); // Redirect to SignInView if not logged in
        }
      },
    );
  }
}
