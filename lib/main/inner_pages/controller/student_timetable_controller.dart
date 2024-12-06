import 'package:cloud_firestore/cloud_firestore.dart';

class TimeTableController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getTimeTable(String className) async {
    try {
      final querySnapshot = await _firestore
          .collection('time_table')
          .where('class', isEqualTo: className)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'day': data['day'],
          'period_start': List<DateTime>.from(data['period_start'].map((timestamp) => (timestamp as Timestamp).toDate())),
          'period_end': List<DateTime>.from(data['period_end'].map((timestamp) => (timestamp as Timestamp).toDate())),
          'subjects': List<String>.from(data['subjects']),
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to load timetable: $e');
    }
  }
}
