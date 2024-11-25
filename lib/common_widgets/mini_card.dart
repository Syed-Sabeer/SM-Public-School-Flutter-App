import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MiniCardGrid extends StatelessWidget {
  final void Function(BuildContext context, int index) onCardTap;

  const MiniCardGrid({Key? key, required this.onCardTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Show 3 cards in a row
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.0, // Adjust aspect ratio for proper card size
      ),
      itemCount: 14, // Number of cards
      itemBuilder: (context, index) {
        return Card(
          elevation: 6,
          color: const Color.fromARGB(255, 229, 235, 245),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              onCardTap(context, index);
            },
            splashColor: Colors.blue.withOpacity(0.3),
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
    );
  }

  // Helper function to get SVG path
  String _getCardSvgPath(int index) {
    switch (index) {
      case 0:
        return 'assets/images/dashboard/notice.svg';
      case 1:
        return 'assets/images/dashboard/attendance.svg';
      case 2:
        return 'assets/images/dashboard/homework.svg';
      case 3:
        return 'assets/images/dashboard/communication.svg';
        case 4:
        return 'assets/images/dashboard/leave.svg';
      case 5:
        return 'assets/images/dashboard/feevoucher.svg';
      case 6:
        return 'assets/images/dashboard/feeledger.svg';
      
        case 7:
        return 'assets/images/dashboard/timetable.svg';
      case 8:
        return 'assets/images/dashboard/syllabus.svg';
      case 9:
        return 'assets/images/dashboard/datesheet.svg';
      case 10:
        return 'assets/images/dashboard/result.svg';
        case 11:
        return 'assets/images/dashboard/zoom.svg';
        case 12:
        return 'assets/images/dashboard/classroom.svg';
        case 13:
        return 'assets/images/dashboard/contact.svg';
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
        return 'Attendance';
      case 2:
        return 'Homework';
      case 3:
        return 'Communication';
      case 4:
        return 'Leaves';
      case 5:
        return 'Fee Voucher';
      case 6:
        return 'Fee Ledger';
      case 7:
        return 'Time Table';
      case 8:
        return 'Syllabus';
      case 9:
        return 'Date Sheet';
        case 10:
        return 'Results';
        case 11:
        return 'Zoom';
        case 12:
        return 'Classroom';
        case 13:
        return 'Contact';
      default:
        return 'Unknown';
    }
  }
}
