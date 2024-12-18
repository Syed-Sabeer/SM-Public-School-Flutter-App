import 'package:cloud_firestore/cloud_firestore.dart';

class StudentFeeVoucherController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch fee data for a specific student ID
  Future<Map<String, dynamic>> getStudentFeeData(String studentId) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('student_fee_voucher')
          .where('student_id', isEqualTo: studentId)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.data() as Map<String, dynamic>;
      } else {
        throw 'No fee data found for student ID: $studentId';
      }
    } catch (e) {
      throw 'Error fetching fee data: $e';
    }
  }

  // Fetch late fee and due charges
  Future<Map<String, dynamic>> getLateFeeCondition() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('fees_condition')
          .doc('4hstCOOHiwJD4T04BON7')
          .get();

      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      throw 'Error fetching late fee condition: $e';
    }
  }

  // Process data for display
  Future<List<Map<String, dynamic>>> getFeeDetails(String studentId) async {
    try {
      final feeData = await getStudentFeeData(studentId);
      final lateFeeCondition = await getLateFeeCondition();

      final List<dynamic> statusList = feeData['status'];
      final List<dynamic> recordList = feeData['record'];
      final List<dynamic> dueList = feeData['due'];
      final List<dynamic> datePaidList = feeData['date_paid'];

      final int deadlineDate = lateFeeCondition['deadline_date'];
      final int dueCharges = lateFeeCondition['due_charges'];

      List<Map<String, dynamic>> feeDetails = [];

      for (int i = 0; i < statusList.length; i++) {
        feeDetails.add({
          'month': _getMonthFromIndex(i), // Convert index to month
          'paidAmount': recordList[i],
          'dueAmount': dueList[i],
          'status': statusList[i], // 1 = Paid, 0 = Not Paid, 2 = Partially Paid
          'datePaid': datePaidList.length > i
              ? (datePaidList[i] as Timestamp).toDate()
              : null,
          'dueCharges': statusList[i] == 2 ? dueCharges : 0,
          'isLate': statusList[i] == 2 || _isLatePayment(datePaidList[i], deadlineDate),
        });
      }

      return feeDetails;
    } catch (e) {
      throw 'Error processing fee details: $e';
    }
  }

  // Check if payment is late
  bool _isLatePayment(Timestamp datePaid, int deadline) {
    if (datePaid == null) return false;
    return datePaid.toDate().day > deadline;
  }

  // Convert index to month name
  String _getMonthFromIndex(int index) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[index % 12];
  }
}
