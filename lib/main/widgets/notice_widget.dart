import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeWidget extends StatelessWidget {
  final String subject;
  final DateTime date;
  final String body;

  const NoticeWidget({
    Key? key,
    required this.subject,
    required this.date,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat('MMM dd, yyyy').format(date),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            body,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
