import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:firebase_core/firebase_core.dart'; // Firebase Initialization
import '../presentation/theme/colortheme.dart';
import '../common_widgets/childDetail_card.dart';
import '../auth/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const ChildrenView());
}

class ChildrenView extends StatefulWidget {
  const ChildrenView({super.key});

  @override
  _ChildrenViewState createState() => _ChildrenViewState();
}

class _ChildrenViewState extends State<ChildrenView> {
  int currentIndex = 0;
  List<Map<String, dynamic>> studentDetails = [];
  List<Map<String, dynamic>> notices = [];
  List<Color> colors = [Cpink, Cblue, Cyellow];

  @override
  void initState() {
    super.initState();
    fetchStudents();
    fetchNotices();
  }

  Future<void> fetchStudents() async {
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) return;

      final authId = authUser.uid;
      final secondarySnapshot = await FirebaseFirestore.instance
          .collection('student_secondary_detail')
          .where('authId', isEqualTo: authId)
          .get();

      if (secondarySnapshot.docs.isEmpty) return;

      final secondaryData = secondarySnapshot.docs.first.data();
      final String fatherCnic = secondaryData['fathercnic'] ?? '';
      final String fatherName = secondaryData['fathername'] ?? 'Unknown';

      final studentSnapshot = await FirebaseFirestore.instance
          .collection('student_detail')
          .where('fathercnic', isEqualTo: fatherCnic)
          .orderBy('createdAt')
          .get();

      if (studentSnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> students = [];
        for (var i = 0; i < studentSnapshot.docs.length; i++) {
          final data = studentSnapshot.docs[i].data();
          final Timestamp dobTimestamp = data['dob'];
          final String formattedDob = DateFormat('dd-MMM-yyyy').format(dobTimestamp.toDate());

          students.add({
            'name': data['fullname'],
            'className': data['class'],
            'section': data['section'],
            'dob': formattedDob,
            'fathercnic': data['fathercnic'],
            'fathername': fatherName,
            'idNumber': data['idNumber'],
            'color': colors[i % colors.length],
          });
        }
        setState(() {
          studentDetails = students;
        });
      }
    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  Future<void> fetchNotices() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('global_notice')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> fetchedNotices = [];
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final Timestamp timestamp = data['createdAt'];
          final String formattedDate = DateFormat('dd-MMM-yyyy').format(timestamp.toDate());
          fetchedNotices.add({
            'date': formattedDate,
            'subject': data['subject'],
            'body': data['body'],
          });
        }
        setState(() {
          notices = fetchedNotices;
        });
      }
    } catch (e) {
      print("Error fetching notices: $e");
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInView()),
      (Route<dynamic> route) => false,
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
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.red,
                size: 28,
              ),
              onPressed: _logout,
            ),
          ],
        ),
        body: studentDetails.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Student Cards Section
                    SizedBox(
                      height: 380,
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
                            context: context,
                            name: student['name'],
                            className: student['className'],
                            section: student['section'],
                            dob: student['dob'],
                            fathercnic: student['fathercnic'],
                            fathername: student['fathername'],
                            idNumber: student['idNumber'],
                            color: student['color'],
                          );
                        },
                      ),
                    ),

                    // Slider Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        studentDetails.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(left: 4, right: 4, top: 10),
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

                    // Notice Section
                    Padding(
                      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              "Notices",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: notices.map((notice) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notice['date'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        notice['subject'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        notice['body'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
