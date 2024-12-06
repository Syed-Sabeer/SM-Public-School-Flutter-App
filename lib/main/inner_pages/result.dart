import 'package:flutter/material.dart';
import './controller/student_result_controller.dart';
import '../widgets/app_bar.dart';

class ResultView extends StatefulWidget {
  final String studentId;

  const ResultView({super.key, required this.studentId});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final StudentResultController _resultController = StudentResultController();
  Map<String, dynamic>? resultData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    try {
      final data = await _resultController.fetchResult(widget.studentId);
      setState(() {
        resultData = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  String calculateGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Result',
        isDashboard: false,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : resultData == null
              ? const Center(child: Text('No results available.'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSummaryCard(), // Summary at the top
                      _buildResultDetails(), // Detailed marks
                    ],
                  ),
                ),
    );
  }

Widget _buildSummaryCard() {
  // Extract summary data
  final subjects = resultData!['subjects'] as List;
  final marks = resultData!['marks'] as List;

  int totalObtainedMarks = 0;
  int totalMaxMarks = 0;

  for (var mark in marks) {
    final parts = mark.split(',');
    totalObtainedMarks += int.parse(parts[0]);
    totalMaxMarks += int.parse(parts[1]);
  }

  final totalPercentage = (totalObtainedMarks / totalMaxMarks) * 100;
  final overallGrade = calculateGrade(totalPercentage);
  final clearedPapers = _calculateClearedPapers();

  return Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9, // Adjust card width
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           Center(
  child: Text(
    resultData!['title'] ?? 'Result Summary',
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center, // Ensures text alignment inside the widget
  ),
),

              const SizedBox(height: 10),
              Text('Total Marks: $totalObtainedMarks / $totalMaxMarks'),
              Text(
                'Total Percentage: ${totalPercentage.toStringAsFixed(2)}%',
              ),
              Text(
                'Overall Grade: $overallGrade',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: overallGrade == 'F' ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Total Cleared Papers: $clearedPapers/${subjects.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: clearedPapers == subjects.length
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Helper function to calculate cleared papers
int _calculateClearedPapers() {
  final marks = resultData!['marks'] as List;
  int clearedPapers = 0;

  for (var mark in marks) {
    final parts = mark.split(',');
    final obtainedMarks = int.parse(parts[0]);
    final totalMarks = int.parse(parts[1]);
    final percentage = (obtainedMarks / totalMarks) * 100;

    if (percentage >= 50) { // Assuming 50% is the passing threshold
      clearedPapers++;
    }
  }
  return clearedPapers;
}


Widget _buildResultDetails() {
  final subjects = resultData!['subjects'] as List;
  final marks = resultData!['marks'] as List;

  return Center(
    child: Container(
      margin: const EdgeInsets.only(top: 20.0), // Apply margin to the container
      width: MediaQuery.of(context).size.width * 0.9, // Same width as the summary card
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), // Top left radius
            topRight: Radius.circular(15), // Top right radius
            bottomLeft: Radius.circular(15), // Bottom left radius
            bottomRight: Radius.circular(15), // Bottom right radius
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full-width colored header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), // Top left radius
                  topRight: Radius.circular(15), // Top right radius
                ),
              ),
              child: const Center(
                child: Text(
                  'Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Table content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                border: TableBorder(
                  top: BorderSide.none, // No top border
                  bottom: BorderSide.none, // No bottom border for the whole table
                  left: BorderSide.none, // No left border
                  right: BorderSide.none, // No right border
                  horizontalInside: BorderSide.none, // No horizontal inner borders
                  verticalInside: BorderSide.none, // No vertical inner borders
                ),
                columnWidths: const {
                  0: FlexColumnWidth(1.7),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1.3),
                },
                children: [
                  // Header row
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Subject',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Obtained',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  // Dynamic rows for subjects
                  for (int index = 0; index < subjects.length; index++)
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300, // Bottom border color
                            width: 0.5, // Bottom border width
                          ),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(subjects[index]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            marks[index].split(',')[1],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            marks[index].split(',')[0],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



}
