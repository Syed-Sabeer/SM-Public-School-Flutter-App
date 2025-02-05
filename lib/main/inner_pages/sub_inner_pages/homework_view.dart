import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/app_bar.dart';
import 'package:intl/intl.dart';

class HomeworkView extends StatelessWidget {
  final String homeworkId;
  const HomeworkView({super.key, required this.homeworkId});

  Future<Map<String, dynamic>> fetchHomeworkDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('class_homework')
          .doc(homeworkId)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('Homework not found');
      }

      return docSnapshot.data()!;
    } catch (e) {
      throw Exception('Failed to load homework details: $e');
    }
  }

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Always white background
      appBar: const CustomAppBar(title: 'Homework Details', isDashboard: false),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchHomeworkDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Homework details not found'));
          }

          final homework = snapshot.data!;
          final subjects = List<String>.from(homework['subject'] ?? []);
          final tasks = List<String>.from(homework['task'] ?? []);
          final createdAt = homework['createdAt'] as Timestamp?;
          final deadlines = (homework['deadline'] as List<dynamic>?)
              ?.map((d) => d as Timestamp)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Created At Date
                if (createdAt != null)
                  Text(
                    "Uploaded on: ${formatDate(createdAt)}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                const SizedBox(height: 12),

                // Homework List
                Expanded(
                  child: ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                              // Subject Title with Icon
                              Row(
                                children: [
                                  Icon(Icons.book_rounded, color: Colors.blue.shade700, size: 22),
                                  const SizedBox(width: 8),
                                  Text(
                                    subjects[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Homework Task
                              Text(
                                tasks[index],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 14),
                              Divider(color: Colors.grey.shade300, thickness: 1),

                              // Deadline Date
                              if (deadlines != null && deadlines.length > index)
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, color: Colors.red, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Due: ${formatDate(deadlines[index])}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
