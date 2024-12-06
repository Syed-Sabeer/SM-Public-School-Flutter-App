import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import './controller/student_notice_controller.dart';
import './sub_inner_pages/notice_view.dart';
import '../widgets/app_bar.dart'; // Import the custom AppBar widget

class NoticesView extends StatefulWidget {
  final String studentId;

  const NoticesView({super.key, required this.studentId});

  @override
  State<NoticesView> createState() => _NoticesViewState();
}

class _NoticesViewState extends State<NoticesView> {
  final StudentNoticeController _noticeController = StudentNoticeController();
  List<Map<String, dynamic>> notices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    try {
      final fetchedNotices =
          await _noticeController.fetchNotices(widget.studentId);
      setState(() {
        notices = fetchedNotices;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Notices',
        isDashboard: false,
      ), // Using the reusable AppBar
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notices.isEmpty
              ? const Center(child: Text('No notices found.'))
              : ListView.builder(
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoticeDetailView(
                              subject: notice['subject'],
                              date: (notice['createdAt'] as Timestamp)
                                  .toDate(),
                              body: notice['body'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    notice['subject'] ?? 'No Subject',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(
                                      (notice['createdAt'] as Timestamp)
                                          .toDate(),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                notice['body'] ?? 'No Content',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

