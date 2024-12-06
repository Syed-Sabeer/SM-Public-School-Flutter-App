import 'package:cloud_firestore/cloud_firestore.dart';

class StudentResultController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchResult(String studentId) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('results')
          .where('student_id', isEqualTo: studentId)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching result: $e');
    }
    return null;
  }
}
