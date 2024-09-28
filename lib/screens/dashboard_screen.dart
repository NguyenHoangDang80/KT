import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'task_list_screen.dart';
import 'setting_screen.dart';
import 'task_statistics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Widget> listBody = [];
  PageController pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    listBody = [
      TaskListScreen(),
      CalendarScreen(),
      TaskStatisticsScreen(),
      SettingScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageViewController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: listBody,
        controller: pageViewController,
        onPageChanged: _onItemTapped,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist, color: Colors.grey), // Icon cho "Công việc"
            label: 'Công việc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, color: Colors.grey), // Icon cho "Lịch"
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart, color: Colors.grey), // Icon cho "Thống kê"
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.grey), // Icon cho "Cài đặt"
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
