// student_card_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main/home_view.dart'; // Make sure to import the HomeView file

// You can also import any custom files like color themes or images.

Widget buildStudentCard({
  required BuildContext context, // Add BuildContext parameter
  required String name,
  required String className,
  required String section,
  required String cnic,
  required String fathercnic,
  required String idNumber,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset(
                'assets/images/dashboard/male_avatar.svg', // Replace with your SVG file path
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            buildInfoRow("Class ", "$className - $section"),
            buildInfoRow("CNIC", cnic),
            buildInfoRow("ID Number", idNumber),
            const SizedBox(height: 16),

            // View Dashboard Button
            ElevatedButton(
              onPressed: () {
                // Navigate to HomeView with student details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeView(
                      fullName: name, // Pass student's full name
                      studentId: idNumber, // Pass student's ID number
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), // Minimized height
              ),
              child: const Text(
                "View Dashboard",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    ),
  );
}
