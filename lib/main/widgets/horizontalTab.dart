import 'package:flutter/material.dart';

class HorizontalTab extends StatelessWidget {
  final List<String> tabs; // Tab titles
  final List<Widget> contents; // Tab contents

  const HorizontalTab({
    super.key,
    required this.tabs,
    required this.contents,
  }) : assert(tabs.length == contents.length,
            'Tabs and contents length must be equal');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length, // Number of tabs dynamically
      child: Column(
        children: [
          // TabBar with a custom look
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                color: Colors.blue, // Active tab background
                borderRadius: BorderRadius.circular(8),
              ),
              dividerColor: Colors.transparent, // Remove bottom border
              indicatorPadding: const EdgeInsets.all(2),
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: tabs.map((title) {
                return Container(
                  height: 36, // Tab height
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
          ),
          // Tab Contents
          Expanded(
            child: TabBarView(
              children: contents,
            ),
          ),
        ],
      ),
    );
  }
}
