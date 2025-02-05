import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/app_bar.dart';

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
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(date);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Notice Detail',
        isDashboard: false,
      ),
      backgroundColor: Colors.white, // White background for the whole page
      body: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Formatted Date Text
              Text(
                "Posted on: $formattedDate",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade600,
                ),
              ),
              const SizedBox(height: 12),

              // Notice Card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Title
                      Text(
                        subject,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Body of the Notice
                      Text(
                        body,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 14),

                      const Divider(color: Colors.grey, thickness: 1),

                      // Close Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.check),
                          label: const Text("Got it"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
