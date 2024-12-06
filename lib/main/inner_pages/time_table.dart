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
                      children: dayTimetable.expand((entry) {
                        final subjects = entry['subjects'] as List<String>;
                        final periodStart = entry['period_start'] as List<DateTime>;
                        final periodEnd = entry['period_end'] as List<DateTime>;

                        return List.generate(subjects.length, (i) {
                          final formattedStart = DateFormat('hh:mm a').format(periodStart[i]);
                          final formattedEnd = DateFormat('hh:mm a').format(periodEnd[i]);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.book,
                                        color: Colors.blue.shade700,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        subjects[i],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '$formattedStart - $formattedEnd',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
