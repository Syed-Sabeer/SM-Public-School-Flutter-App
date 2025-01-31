import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

class HomeworkList extends StatelessWidget {
  final String studentId;
  const HomeworkList({super.key, required this.studentId});

  Future<String> fetchStudentClass() async {
    try {
      final studentSnapshot = await FirebaseFirestore.instance
          .collection('student_detail')
          .where('idNumber', isEqualTo: studentId)
          .limit(1)
          .get();

      if (studentSnapshot.docs.isEmpty) {
        throw Exception('Student not found');
      }

      return studentSnapshot.docs.first.data()['class'] as String;
    } catch (e) {
      throw Exception('Failed to load student class: $e');
    }
  }

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
      appBar: const CustomAppBar(title: 'Homework', isDashboard: false),
      body: FutureBuilder<String>(
        future: fetchStudentClass(),
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
                return const Center(child: Text('No homework available'));
              }

              final homeworkList = snapshot.data!;

              return ListView.builder(
                itemCount: homeworkList.length,
                itemBuilder: (context, index) {
                  final homework = homeworkList[index];
                  final date = homework['createdAt'] as DateTime;
                  final formattedDate = "${date.year}-${date.month}-${date.day}";
                  final day = "${['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][date.weekday - 1]}";

                  return ListTile(
                    title: Text("$formattedDate ($day)"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeworkView(homeworkId: homework['id']),
                        ),
                      );
                    },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(subjects[index]),
                    subtitle: Text(tasks[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
