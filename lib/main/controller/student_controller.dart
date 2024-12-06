import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class StudentController {
  // Function to fetch student details
  Future<List<Map<String, dynamic>>> fetchStudents() async {
    List<Map<String, dynamic>> students = [];
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) return students;

      final authId = authUser.uid;
      final secondarySnapshot = await FirebaseFirestore.instance
          .collection('student_secondary_detail')
          .where('authId', isEqualTo: authId)
          .get();

      if (secondarySnapshot.docs.isEmpty) {
        return students;
      }

      // Get fathername and fathercnic from secondary collection
      final secondaryData = secondarySnapshot.docs.first.data();
      final String fatherCnic = secondaryData['fathercnic'] ?? '';
      final String fatherName = secondaryData['fathername'] ?? 'Unknown';

      final studentSnapshot = await FirebaseFirestore.instance
          .collection('student_detail')
          .where('fathercnic', isEqualTo: fatherCnic)
          .orderBy('createdAt')
          .get();

      if (studentSnapshot.docs.isNotEmpty) {
        for (var i = 0; i < studentSnapshot.docs.length; i++) {
          final data = studentSnapshot.docs[i].data();
          final Timestamp dobTimestamp = data['dob'];
          final String formattedDob =
              DateFormat('dd-MMM-yyyy').format(dobTimestamp.toDate());

          students.add({
            'name': data['fullname'],
            'className': data['class'],
            'section': data['section'],
            'dob': formattedDob,
            'fathercnic': data['fathercnic'],
            'fathername': fatherName,
            'idNumber': data['idNumber'],
            'colorIndex': i, // To assign color later in the view
          });
        }
      }
    } catch (e) {
      print("Error fetching students: $e");
    }
    return students;
  }

  // Example utility function to get a student name by ID
  String? getStudentNameById(List<Map<String, dynamic>> students, String id) {
    final student =
        students.firstWhere((student) => student['idNumber'] == id, orElse: () => {});
    return student.isNotEmpty ? student['name'] : null;
  }
}
