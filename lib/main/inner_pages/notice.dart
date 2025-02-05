import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import './controller/student_notice_controller.dart';
import './sub_inner_pages/notice_view.dart';
import '../widgets/app_bar.dart';

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
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notices.isEmpty
              ? const EmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    final formattedDate = DateFormat('EEE, MMM d, yyyy').format(
                      (notice['createdAt'] as Timestamp).toDate(),
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoticeDetailView(
                              subject: notice['subject'],
                              date: (notice['createdAt'] as Timestamp).toDate(),
                              body: notice['body'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Subject & Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notice['subject'] ?? 'No Subject',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.blueAccent,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Notice Body Preview
                            Text(
                              notice['body'] ?? 'No Content',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No notices found.', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}
