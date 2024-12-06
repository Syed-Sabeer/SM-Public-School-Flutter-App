import 'package:cloud_firestore/cloud_firestore.dart';

class StudentNoticeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchNotices(String studentId) async {
  try {
    print('Fetching student details for ID: $studentId');

    // Fetch the student's class using the correct field name
    final studentSnapshot = await _firestore
        .collection('student_detail')
        .where('idNumber', isEqualTo: studentId) // Adjust field name if needed
        .limit(1)
        .get();

    if (studentSnapshot.docs.isEmpty) {
      print('No matching student found for ID: $studentId');
      return [];
    }

    final studentData = studentSnapshot.docs.first.data();
    final studentClass = studentData['class'] as String;

    print('Student found: $studentData');
    print('Student class: $studentClass');

    // Fetch personal notices
    final personalNoticesSnapshot = await _firestore
        .collection('student_notice')
        .where('student_id', isEqualTo: studentId)
        .get();

    final personalNotices = personalNoticesSnapshot.docs.map((doc) {
      final data = doc.data();
      data['type'] = 'personal';
      return data;
    }).toList();

    // Fetch class notices
    final classNoticesSnapshot = await _firestore
        .collection('class_notice')
        .where('class', isEqualTo: studentClass)
        .get();

    final classNotices = classNoticesSnapshot.docs.map((doc) {
      final data = doc.data();
      data['type'] = 'class';
      return data;
    }).toList();

    // Combine and sort notices
    final combinedNotices = [...personalNotices, ...classNotices];
    combinedNotices.sort((a, b) {
      final dateA = (a['createdAt'] as Timestamp).toDate();
      final dateB = (b['createdAt'] as Timestamp).toDate();
      return dateB.compareTo(dateA); // Latest first
    });

    print('Combined notices count: ${combinedNotices.length}');
    return combinedNotices;
  } catch (e) {
    print('Error fetching notices: $e');
    throw 'Error fetching notices: $e';
  }
}


}
