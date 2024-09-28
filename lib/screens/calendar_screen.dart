import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobi/service/api_service.dart';

import 'task_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final ApiService apiService = ApiService();
  late DateTime selectedDay; // Ngày được chọn
  late List<Map<String, dynamic>> selectedTasks; // Công việc trong ngày đã chọn

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    selectedTasks = [];
    fetchTasks(); // Lấy danh sách công việc
  }

  Future<void> fetchTasks() async {
    try {
      final fetchedTasks = await apiService.fetchTasks();
      print("Fetched tasks: $fetchedTasks"); // Kiểm tra dữ liệu trả về
      selectedTasks = await apiService.fetchTasksByDate(selectedDay); // Cập nhật công việc cho ngày hiện tại
      setState(() {
        selectedTasks = selectedTasks;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void onDaySelected(DateTime day, DateTime focusedDay) async {
    setState(() {
      selectedDay = day;
    });

    try {
      selectedTasks = await apiService.fetchTasksByDate(selectedDay);
      print("Tasks for selected day ($selectedDay): $selectedTasks"); // Kiểm tra danh sách công việc
      setState(() {
        selectedTasks = selectedTasks;
      });
    } catch (e) {
      print('Error fetching tasks for selected date: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch Công Việc'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: onDaySelected,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2101, 1, 1),
          ),
          Expanded(
            child: selectedTasks.isEmpty
                ? Center(child: Text('Không có công việc cho ngày này')) // Thông báo nếu không có công việc
                : ListView.builder(
                    itemCount: selectedTasks.length,
                    itemBuilder: (context, index) {
                      final task = selectedTasks[index];
                      return ListTile(
                        title: Text(task['name'] ?? 'Unnamed Task'),
                        subtitle: Text('Trạng thái: ${task['status'] ?? 'Chưa xác định'}'),
                        onTap: () {
                          // Chuyển đến màn hình chi tiết công việc
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(task: task),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
