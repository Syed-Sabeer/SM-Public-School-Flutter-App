import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/horizontaltab.dart';
import 'widgets/fee_voucher_widget.dart';

class FeeVoucherView extends StatelessWidget {
  const FeeVoucherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Fee Voucher',
        isDashboard: false,
      ),
      backgroundColor: Colors.white,
      body: HorizontalTab(
        tabs: ['Unpaid Vouchers', 'Paid Vouchers'],
        contents: [
          // Unpaid Vouchers Tab Content
          ListView(
            children: const [
              FeeVoucherWidget(
                invoiceDate: 'December 02 2024',
                dueDate: 'December 22 2024',
                feeCycle: 'December 2024',
                voucherAmount: '6,768',
                paidDate: 'Not Paid',
                isPaid: false,
              ),
              FeeVoucherWidget(
                invoiceDate: 'November 05 2024',
                dueDate: 'November 22 2024',
                feeCycle: 'November 2024',
                voucherAmount: '6,768',
                paidDate: 'Not Paid',
                isPaid: false,
              ),
            ],
          ),
          // Paid Vouchers Tab Content
          ListView(
            children: const [
              FeeVoucherWidget(
                invoiceDate: 'October 01 2024',
                dueDate: 'October 22 2024',
                feeCycle: 'October 2024',
                voucherAmount: '6,768',
                paidDate: 'October 04 2024',
                isPaid: true,
              ),
              FeeVoucherWidget(
                invoiceDate: 'November 05 2024',
                dueDate: 'November 22 2024',
                feeCycle: 'November 2024',
                voucherAmount: '6,768',
                paidDate: 'November 15 2024',
                isPaid: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
