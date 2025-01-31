import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import './sub_inner_pages/homework_view.dart';

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
       backgroundColor: Colors.white,
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
                return EmptyState();
              }

              final homeworkList = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: homeworkList.length,
                  itemBuilder: (context, index) {
                    final homework = homeworkList[index];
                    final date = homework['createdAt'] as DateTime;
                    final formattedDate = "${date.year}-${date.month}-${date.day}";
                    final day = "${['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][date.weekday - 1]}";

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text("$formattedDate ($day)", style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeworkView(homeworkId: homework['id']),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
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
          Icon(Icons.assignment_late, size: 50, color: Colors.grey),
          SizedBox(height: 16),
          Text('No homework available', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}
