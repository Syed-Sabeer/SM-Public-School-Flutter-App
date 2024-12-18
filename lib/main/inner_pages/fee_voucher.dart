import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';


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
      );
  }
}
