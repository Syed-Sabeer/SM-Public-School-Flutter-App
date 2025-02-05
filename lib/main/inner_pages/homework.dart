import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import './sub_inner_pages/homework_view.dart';
import './controller/class_fetch_controller.dart';

class HomeworkList extends StatelessWidget {
  final String studentId;
  HomeworkList({super.key, required this.studentId});

  final StudentFetchController _studentFetchController = StudentFetchController();

  Future<List<Map<String, dynamic>>> fetchHomeworkDates(String className) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('class_homework')
          .where('class', isEqualTo: className)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'createdAt': (data['createdAt'] as Timestamp).toDate(),
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to load homework dates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Homework', isDashboard: false),
      body: FutureBuilder<String>(
        future: _studentFetchController.fetchStudentClass(studentId),
        builder: (context, classSnapshot) {
          if (classSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (classSnapshot.hasError) {
            return Center(child: Text('Error: ${classSnapshot.error}'));
          }

          final className = classSnapshot.data!;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchHomeworkDates(className),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const EmptyState();
              }

              final homeworkList = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: homeworkList.length,
                itemBuilder: (context, index) {
                  final homework = homeworkList[index];
                  final date = homework['createdAt'] as DateTime;
                  final formattedDate = "${date.year}-${date.month}-${date.day}";
                  final day = "${['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][date.weekday - 1]}";

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeworkView(homeworkId: homework['id']),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
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
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Homework Date & Day
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          // Forward Icon
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment_late, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No homework available', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}
