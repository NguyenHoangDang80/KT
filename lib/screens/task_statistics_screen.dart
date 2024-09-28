import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../service/api_service.dart';

class TaskStatisticsScreen extends StatefulWidget {
  @override
  _TaskStatisticsScreenState createState() => _TaskStatisticsScreenState();
}

class _TaskStatisticsScreenState extends State<TaskStatisticsScreen> {
  int completedTasks = 0;
  int newTasks = 0;
  int inProgressTasks = 0;
  int finishedTasks = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final statistics = await ApiService().fetchTaskStatistics();
      setState(() {
        completedTasks = statistics['completed'] ?? 0;
        newTasks = statistics['new'] ?? 0;
        inProgressTasks = statistics['inProgress'] ?? 0;
        finishedTasks = statistics['finished'] ?? 0; // Cập nhật số lượng công việc đã kết thúc
      });
    } catch (e) {
      print('Error fetching statistics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống Kê Công Việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Thống Kê Công Việc',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: completedTasks.toDouble(),
                      title: 'Hoàn Thành: $completedTasks',
                      color: Colors.green,
                    ),
                    PieChartSectionData(
                      value: newTasks.toDouble(),
                      title: 'Mới Tạo: $newTasks',
                      color: Colors.blue,
                    ),
                    PieChartSectionData(
                      value: inProgressTasks.toDouble(),
                      title: 'Đang Thực Hiện: $inProgressTasks',
                      color: Colors.orange,
                    ),
                    PieChartSectionData(
                      value: finishedTasks.toDouble(),
                      title: 'Đã Kết Thúc: $finishedTasks', // Biểu đồ cho trạng thái đã kết thúc
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
