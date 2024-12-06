import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isDashboard;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.isDashboard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          isDashboard ? Icons.logout : Icons.arrow_back,
          color: isDashboard ? Colors.red : Colors.blue,
        ),
        onPressed: () {
          if (isDashboard) {
            Navigator.pop(context); // Navigate back for non-dashboard pages
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: isDashboard
          ? [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.blue),
                onPressed: () {
                  // Home button functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.group, color: Colors.blue),
                onPressed: () {
                  // Group button functionality
                },
              ),
            ]
          : null, // No icons on non-dashboard pages
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
