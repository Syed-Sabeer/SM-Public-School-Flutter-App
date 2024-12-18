import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_bar.dart';
import '../widgets/horizontaltab.dart';
import 'widgets/fee_voucher_widget.dart';

class FeeVoucherView extends StatefulWidget {
  const FeeVoucherView({super.key});

  @override
  State<FeeVoucherView> createState() => _FeeVoucherViewState();
}

class _FeeVoucherViewState extends State<FeeVoucherView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> debugFirestore() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('student_fees')
      .get();

  for (var doc in querySnapshot.docs) {
    print(doc.data()); // Print each document's data
  }
}


  // Fetch data for unpaid and paid vouchers
  Future<List<Map<String, dynamic>>> fetchFeeVouchers() async {
    try {
      // Replace '74' with the logged-in student ID dynamically if needed
      QuerySnapshot query = await _firestore
          .collection('student_fees')
     .where('student_id', isEqualTo: 74) // Use int instead of String

          .get();

      if (query.docs.isNotEmpty) {
        final feeData = query.docs.first.data() as Map<String, dynamic>;
        final statusList = feeData['status'] as List<dynamic>;
        final recordList = feeData['record'] as List<dynamic>;
        final dueList = feeData['due'] as List<dynamic>;
        final datePaidList = feeData['date_paid'] as List<dynamic>;

        List<Map<String, dynamic>> result = [];
        for (int i = 0; i < statusList.length; i++) {
          result.add({
            'invoiceDate': '01 ${_getMonth(i)} 2024',
            'dueDate': '22 ${_getMonth(i)} 2024',
            'feeCycle': '${_getMonth(i)} 2024',
            'voucherAmount': dueList[i] + recordList[i],
            'paidDate': statusList[i] == 1
                ? _formatDate(datePaidList[i])
                : 'Not Paid',
            'isPaid': statusList[i] == 1,
          });
        }
        return result;
      }
      throw 'No data found';
    } catch (e) {
      throw 'Error fetching fee vouchers: $e';
    }
  }

  // Helper to get month name
  String _getMonth(int index) {
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

  // Format Timestamp to Date
  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day} ${_getMonth(date.month - 1)} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Fee Voucher',
        isDashboard: false,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFeeVouchers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final vouchers = snapshot.data!;

          // Separate paid and unpaid vouchers
          final unpaidVouchers = vouchers.where((v) => !v['isPaid']).toList();
          final paidVouchers = vouchers.where((v) => v['isPaid']).toList();

          return HorizontalTab(
            tabs: ['Unpaid Vouchers', 'Paid Vouchers'],
            contents: [
              // Unpaid Vouchers Tab
              ListView.builder(
                itemCount: unpaidVouchers.length,
                itemBuilder: (context, index) {
                  final voucher = unpaidVouchers[index];
                  return FeeVoucherWidget(
                    invoiceDate: voucher['invoiceDate'],
                    dueDate: voucher['dueDate'],
                    feeCycle: voucher['feeCycle'],
                    voucherAmount: voucher['voucherAmount'].toString(),
                    paidDate: voucher['paidDate'],
                    isPaid: voucher['isPaid'],
                  );
                },
              ),
              // Paid Vouchers Tab
              ListView.builder(
                itemCount: paidVouchers.length,
                itemBuilder: (context, index) {
                  final voucher = paidVouchers[index];
                  return FeeVoucherWidget(
                    invoiceDate: voucher['invoiceDate'],
                    dueDate: voucher['dueDate'],
                    feeCycle: voucher['feeCycle'],
                    voucherAmount: voucher['voucherAmount'].toString(),
                    paidDate: voucher['paidDate'],
                    isPaid: voucher['isPaid'],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
