import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Home View',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main User Card
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purpleAccent, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Student | Class: 10 | Section: A',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Email: johndoe@example.com',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Grid of smaller cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Show 3 cards in a row
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0, // Adjust aspect ratio for proper card size
              ),
              itemCount: 8, // Number of cards
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      _navigateToFeature(context, index);
                    },
                    splashColor: Colors.purpleAccent.withOpacity(0.3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    SvgPicture.asset(
  _getCardSvgPath(index),
  height: 40,
  width: 40,
),

                        const SizedBox(height: 8),
                        Text(
                          _getCardTitle(index),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Navigation based on card index
  void _navigateToFeature(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkView()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassesView()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticesView()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceView()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeworkView()));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LeavesView()));
        break;
      case 6:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TimeTableView()));
        break;
      case 7:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultsView()));
        break;
      default:
        // Handle unknown case
        break;
    }
  }

  // Helper function to get SVG path
  String _getCardSvgPath(int index) {
    switch (index) {
      case 0:
        return 'assets/icons/work.svg';
      case 1:
        return 'assets/icons/classes.svg';
      case 2:
        return 'assets/icons/homework.svg';
      case 3:
        return 'assets/icons/attendance.svg';
      case 4:
        return 'assets/images/dashboard/timetable.svg';
      case 5:
        return 'assets/icons/leaves.svg';
      case 6:
        return 'assets/images/dashboard/.svg';
      case 7:
        return 'assets/images/dashboard/.svg';
        case 8:
        return 'assets/images/dashboard/.svg';
        case 9:
        return 'assets/images/dashboard/result.svg';
      default:
        return 'assets/icons/unknown.svg';
    }
  }

  // Helper function to get card title
  String _getCardTitle(int index) {
    switch (index) {
      case 0:
        return 'Notice';
      case 1:
        return 'Attendace';
      case 2:
        return 'Homework';
      case 3:
        return 'Academic Calendar';
      case 4:
        return 'Time Table';
      case 5:
        return 'Fee Ledger';
      case 6:
        return 'Fee Voucher';
      case 7:
        return 'Syllabus';
        case 8:
        return 'Datesheet';
        case 9:
        return 'Result';
      default:
        return 'Unknown';
    }
  }
}

// Example Views
class WorkView extends StatelessWidget {
  const WorkView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Work View")));
  }
}

class ClassesView extends StatelessWidget {
  const ClassesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Classes View")));
  }
}

// Define other views similarly...
class NoticesView extends StatelessWidget {
  const NoticesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Notices View")));
  }
}

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Attendance View")));
  }
}

class HomeworkView extends StatelessWidget {
  const HomeworkView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Homework View")));
  }
}

class LeavesView extends StatelessWidget {
  const LeavesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Leaves View")));
  }
}

class TimeTableView extends StatelessWidget {
  const TimeTableView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Time Table View")));
  }
}

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Results View")));
  }
}
