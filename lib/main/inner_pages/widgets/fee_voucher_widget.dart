import 'package:flutter/material.dart';

class FeeVoucherWidget extends StatelessWidget {
  final String invoiceDate;
  final String dueDate;
  final String feeCycle;
  final String voucherAmount;
  final String paidDate;
  final bool isPaid;

  const FeeVoucherWidget({
    super.key,
    required this.invoiceDate,
    required this.dueDate,
    required this.feeCycle,
    required this.voucherAmount,
    required this.paidDate,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn('Invoice Date', invoiceDate),
                _buildColumn('Due Date', dueDate),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColumn('Fee Cycle', feeCycle),
                _buildColumn('Voucher Amount', voucherAmount),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Download Voucher'),
                ),
                _buildColumn('Paid Date', paidDate,
                    color: isPaid ? Colors.green : Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, String value, {Color color = Colors.black}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
