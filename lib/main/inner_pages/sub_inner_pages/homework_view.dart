import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';

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
      backgroundColor: Colors.white,
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
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(subjects[index], style: TextStyle(fontWeight: FontWeight.bold)),
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
