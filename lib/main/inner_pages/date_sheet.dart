import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatesheetView extends StatelessWidget {
  const DatesheetView({super.key});

  Future<List<Map<String, dynamic>>> fetchDateSheet() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('date_sheet').get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception('No date sheet available');
      }
      
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      
      List<Timestamp> startTimes = List<Timestamp>.from(data['date_time_start'] ?? []);
      List<Timestamp> endTimes = List<Timestamp>.from(data['date_time_end'] ?? []);
      List<String> subjects = List<String>.from(data['subject'] ?? []);
      
      List<Map<String, dynamic>> dateSheet = [];
      for (int i = 0; i < subjects.length; i++) {
        dateSheet.add({
          'subject': subjects[i],
          'startTime': startTimes[i].toDate(),
          'endTime': endTimes[i].toDate(),
        });
      }
      return dateSheet;
    } catch (e) {
      throw Exception('Failed to load date sheet: $e');
    }
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEEE, MMM d').format(date);
    }
  }

  String formatTimeRange(DateTime start, DateTime end) {
    final timeFormat = DateFormat('h:mm a');
    return "${timeFormat.format(start)} - ${timeFormat.format(end)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Always white background
      appBar: const CustomAppBar(title: 'Date Sheet', isDashboard: false),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDateSheet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No date sheet available'));
          }

          final dateSheet = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: dateSheet.length,
            itemBuilder: (context, index) {
              final item = dateSheet[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                      // Date & Icon Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDate(item['startTime']),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          Icon(
                            Icons.date_range_rounded,
                            color: Colors.blue.shade600,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Time Row
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(
                            formatTimeRange(item['startTime'], item['endTime']),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Divider(color: Colors.grey.shade300, thickness: 1),

                      // Subject Name
                      Text(
                        item['subject'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
