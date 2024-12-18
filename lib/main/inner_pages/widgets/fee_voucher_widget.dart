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
    this.isPaid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: isPaid ? Colors.green : Colors.red,
              width: 4,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row - Invoice Date and Due Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetail('Invoice Date', invoiceDate),
                _buildDetail('Due Date', dueDate),
              ],
            ),
            const SizedBox(height: 8),

            // Middle Row - Fee Cycle and Voucher Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetail('Fee Cycle', feeCycle, bold: true),
                _buildDetail('Voucher Amount', voucherAmount, bold: true),
              ],
            ),
            const SizedBox(height: 12),

            // Download Button and Paid Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle download logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Download Voucher',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  'Paid Date\n$paidDate',
                  style: TextStyle(
                    color: isPaid ? Colors.green : Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method to Build Details
  Widget _buildDetail(String title, String value, {bool bold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
