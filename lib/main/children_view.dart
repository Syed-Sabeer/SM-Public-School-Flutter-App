import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase_core/firebase_core.dart'; // Firebase Initialization
import '../presentation/theme/colortheme.dart';
import '../common_widgets/childDetail_card.dart'; // Import the new file
import '../auth/signin.dart'; // Make sure this is your SignInView import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(ChildrenView());
}

class ChildrenView extends StatefulWidget {
  const ChildrenView({super.key});

  @override
  _ChildrenViewState createState() => _ChildrenViewState();
}

class _ChildrenViewState extends State<ChildrenView> {
  int currentIndex = 0; // To track the active page
  List<Map<String, dynamic>> studentDetails = []; // To hold fetched student data
  List<Color> colors = [Cpink, Cblue, Cyellow]; // Cycle colors

  @override
  void initState() {
    super.initState();
    fetchStudents(); // Fetch student records dynamically
  }

  Future<void> fetchStudents() async {
    try {
      final authUser = FirebaseAuth.instance.currentUser; // Current logged-in user
      if (authUser == null) return;

      final authId = authUser.uid;

      // Fetch `student_secondary_detail` where `authId` matches
      final secondarySnapshot = await FirebaseFirestore.instance
          .collection('student_secondary_detail')
          .where('authId', isEqualTo: authId)
          .get();

      print('student_secondary_detail query result: ${secondarySnapshot.docs.length} documents found.');

      if (secondarySnapshot.docs.isEmpty) {
        print('No student_secondary_detail found for this user.');
        return;
      }

      final fatherCnic = secondarySnapshot.docs.first['fathercnic'];

      print('fathercnic: $fatherCnic');

      // Fetch `student_detail` where `fathercnic` matches
      final studentSnapshot = await FirebaseFirestore.instance
          .collection('student_detail')
          .where('fathercnic', isEqualTo: fatherCnic)
          .orderBy('createdAt') // Order by creation time
          .get();

      print('student_detail query result: ${studentSnapshot.docs.length} documents found.');

      if (studentSnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> students = [];
        for (var i = 0; i < studentSnapshot.docs.length; i++) {
          final data = studentSnapshot.docs[i].data();
          students.add({
            'name': data['fullname'],
            'className': data['class'],
            'section': data['section'],
            'cnic': data['cnic'],
            'fathercnic': data['fathercnic'],
            'idNumber': data['idNumber'],
            'color': colors[i % colors.length], // Assign color in sequence
          });
        }
        setState(() {
          studentDetails = students; // Update state with fetched students
        });
      } else {
        print('No students found for fathercnic: $fatherCnic');
      }
    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  // Function to log out the user and restart the app from main.dart
  void _logout() async {
    await FirebaseAuth.instance.signOut(); // Log out the user
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInView()), // Navigate to SignInView after logout
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
   
 home: Scaffold(
  appBar: AppBar(
    title: const Text(
      'Student Detail',
      style: TextStyle(
        color: Colors.black, 
        fontSize: 18,
        fontWeight: FontWeight.bold, // Make the text bold
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: false, // Remove default back button
    actions: [
      IconButton(
        icon: const Icon(
          Icons.power_settings_new, // Power icon for logout
          color: Colors.red,
          size: 28, // Adjust size as needed
        ),
        onPressed: _logout, // Logout functionality
      ),
    ],
  ),

        body: studentDetails.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Show loader
            : Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemCount: studentDetails.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final student = studentDetails[index];
                        return buildStudentCard(
                          context: context, // Pass the context here
                          name: student['name'],
                          className: student['className'],
                          section: student['section'],
                          cnic: student['cnic'],
                          fathercnic: student['fathercnic'],
                          idNumber: student['idNumber'],
                          color: student['color'],
                        );
                      },
                    ),
                  ),
                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      studentDetails.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: currentIndex == index ? 16 : 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? studentDetails[index]['color']
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
