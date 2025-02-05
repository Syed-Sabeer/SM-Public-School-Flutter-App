import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import 'package:intl/intl.dart';
import 'controller/student_timetable_controller.dart';

class TimeTableView extends StatefulWidget {
  final String className;

  const TimeTableView({Key? key, required this.className}) : super(key: key);

  @override
  _TimeTableViewState createState() => _TimeTableViewState();
}

class _TimeTableViewState extends State<TimeTableView>
    with SingleTickerProviderStateMixin {
  final TimeTableController _controller = TimeTableController();
  late Future<List<Map<String, dynamic>>> _timetableFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _timetableFuture = _controller.getTimeTable(widget.className);
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Time Table',
        isDashboard: false,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _timetableFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No timetable available.'));
          }

          final timetable = snapshot.data!;
          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

          return Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.black,
                  indicatorColor: Colors.blue,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  tabs: days
                      .map((day) => Tab(
                            child: Text(
                              day,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ))
                      .toList(),
                ),
                
              ),
              
            Expanded(
  child: TabBarView(
    controller: _tabController,
    children: days.map((day) {
      final dayTimetable = timetable.where((entry) => entry['day'] == day).toList();

      if (dayTimetable.isEmpty) {
        return const Center(child: Text('No timetable for this day.'));
      }

      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 10), // Added padding for top/bottom
        children: dayTimetable.expand((entry) {
          final subjects = entry['subjects'] as List<String>;
          final periodStart = entry['period_start'] as List<DateTime>;
          final periodEnd = entry['period_end'] as List<DateTime>;

          return List.generate(subjects.length, (i) {
            final formattedStart = DateFormat('hh:mm a').format(periodStart[i]);
            final formattedEnd = DateFormat('hh:mm a').format(periodEnd[i]);

            return GestureDetector(
              onTap: () {
                // Handle item tap if needed
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5, // Increased shadow for better contrast
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // More rounded corners
                ),
                color: Colors.white,
                shadowColor: Colors.black.withOpacity(0.1), // Soft shadow effect
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.book_rounded,
                            color: Colors.blue.shade700,
                            size: 28, // Larger icon for better clarity
                          ),
                          const SizedBox(width: 12),
                          Text(
                            subjects[i],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600, // Bold text for subject name
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.green.shade600,
                            size: 22, // Larger icon
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$formattedStart - $formattedEnd',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600, // Softer text for timing
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        }).toList(),
      );
    }).toList(),
  ),
),

            ],
          );
        },
      ),
    );
  }
}
