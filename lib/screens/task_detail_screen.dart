import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện để định dạng ngày
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem có ngày hay không, nếu có thì định dạng thành thứ và ngày
    String taskDate = task['date'] != null
        ? DateFormat('EEEE, dd/MM/yyyy').format(DateFormat('EEEE, dd/MM/yyyy').parse(task['date']))
        : 'Chưa có ngày';

    // Kiểm tra thời gian bắt đầu và kết thúc
    String startTime = task['start_time'] != null ? task['start_time'] : 'Chưa có thời gian bắt đầu';
    String endTime = task['end_time'] != null ? task['end_time'] : 'Chưa có thời gian kết thúc';

    return Scaffold(
      appBar: AppBar(
        title: Text(task['name'] ?? 'Công Việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Địa Điểm: ${task['location'] ?? 'Không xác định'}'),
            Text('Người Chủ Trì: ${task['leader'] ?? 'Không xác định'}'), // Sửa 'owner' thành 'leader'
            Text('Ghi Chú: ${task['notes'] ?? 'Không có ghi chú'}'),
            Text('Trạng Thái: ${task['status'] ?? 'Chưa xác định'}'),
            Text('Ngày Thực Hiện: $taskDate'), // Hiển thị thứ và ngày
            Text('Thời Gian Bắt Đầu: $startTime'), // Hiển thị thời gian bắt đầu
            Text('Thời Gian Kết Thúc: $endTime'), // Hiển thị thời gian kết thúc
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
                ); // Chuyển đến màn hình sửa công việc
              },
              child: Text('Sửa Công Việc'),
            ),
          ],
        ),
      ),
    );
  }
}
