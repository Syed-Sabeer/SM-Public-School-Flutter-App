import 'package:cloud_firestore/cloud_firestore.dart';

class StudentFetchController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> fetchStudentClass(String studentId) async {
    try {
      final studentSnapshot = await _firestore
          .collection('student_detail')
          .where('idNumber', isEqualTo: studentId)
          .limit(1)
          .get();

      if (studentSnapshot.docs.isEmpty) {
        throw Exception('Student not found');
      }

      return studentSnapshot.docs.first.data()['class'] as String;
    } catch (e) {
      throw Exception('Failed to load student class: $e');
    }
  }
}
