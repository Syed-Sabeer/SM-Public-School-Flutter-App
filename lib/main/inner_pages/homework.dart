import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

class HomeworkView extends StatelessWidget {
  const HomeworkView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Homework',
        isDashboard: false,
      ),
      backgroundColor: Colors.white,
      );
  }


  
}
