import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main/home_view.dart'; // Ensure to import the HomeView file

Widget buildStudentCard({
  required BuildContext context, // Add BuildContext parameter
  required String name,
  required String className,
  required String section,
  required String dob,
  required String fathercnic,
  required String idNumber,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 23),
    child: Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: SingleChildScrollView( // Ensure the content scrolls if needed
          child: Column(
            mainAxisSize: MainAxisSize.min,  // This will allow the Column to take only as much height as needed
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(16),
                child: SvgPicture.asset(
                  'assets/images/dashboard/male_avatar.svg',
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
              buildInfoRow("Class", "$className - $section"),
              buildInfoRow("Date of Birth", dob),
              buildInfoRow("ID Number", idNumber),
              const SizedBox(height: 16),

              // Add extra padding or margin here to ensure the button is visible
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Add bottom padding here
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(
                          fullName: name,
                          studentId: idNumber,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: const Text(
                    "View Dashboard",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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
