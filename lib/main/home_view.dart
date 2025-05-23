import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common_widgets/mini_card.dart';
import '../main/inner_pages/attendace.dart';
import '../main/inner_pages/time_table.dart';
import '../main/inner_pages/syllabus.dart';
import '../main/inner_pages/notice.dart';
import '../main/inner_pages/leaves.dart';
import '../main/inner_pages/homework.dart';
import '../main/inner_pages/fee_voucher.dart';
import '../main/inner_pages/fee_ledger.dart';
import '../main/inner_pages/date_sheet.dart';
import '../main/inner_pages/communication.dart';
import '../main/inner_pages/result.dart';

class HomeView extends StatelessWidget {
  final String fullName;
  final String studentId;

  const HomeView({
    super.key,
    required this.fullName,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.white,
        ),
         title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.red),  // Use back arrow icon
          onPressed: () {
            Navigator.pop(context);  // Go back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.blue),
            onPressed: () {
              // Add home button functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.group, color: Colors.blue),
            onPressed: () {
              // Add group button functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main User Card with dynamic data
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 229, 235, 245),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 4.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: SvgPicture.asset(
                                'assets/images/dashboard/male_avatar.svg',
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName, // Display the full name dynamically
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ' Father: James Bond', // You can pass or fetch father's name dynamically
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ' Class: 10 - A', // Class and Section can be dynamic as well if needed
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ' ID: $studentId', // Display the student ID dynamically
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 123, 123, 123)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Grid of smaller cards
              MiniCardGrid(
                  onCardTap: (context, index) =>
                      _navigateToFeature(context, index)),

              // Footer Row with Icons and Text
            ],
          ),
        ),
      ),
    );
  }

  // Navigation based on card index
  void _navigateToFeature(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NoticesView()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AttendanceView()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeworkView()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CommunicationView()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LeavesView()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FeeVoucherView()));
        break;
      case 6:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FeeLedgerView()));
        break;
      case 7:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResultsView()));
        break;
      default:
        // Handle unknown cases if needed
        break;
    }
  }
}
