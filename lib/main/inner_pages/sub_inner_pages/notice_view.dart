import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/notice_widget.dart'; // Import NoticeWidget

class NoticeDetailView extends StatelessWidget {
  final String subject;
  final DateTime date;
  final String body;

  const NoticeDetailView({
    super.key,
    required this.subject,
    required this.date,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Notice Detail',
        isDashboard: false,
      ),
      backgroundColor: Colors.white,
      body: NoticeWidget(
        subject: subject,
        date: date,
        body: body,
      ),
    );
  }
}
