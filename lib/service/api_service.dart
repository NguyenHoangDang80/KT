import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = 'https://mobi-ac06e-default-rtdb.firebaseio.com';

  // Lấy danh sách công việc
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks.json'));

    if (response.statusCode == 200) {
      // Chuyển đổi JSON thành danh sách
      final Map<dynamic, dynamic> decodedResponse = json.decode(response.body);
      print("Decoded response: $decodedResponse"); // In ra để kiểm tra
      return decodedResponse.entries.map((entry) {
        return {
          'id': entry.key, // Lưu ID của task
          ...entry.value as Map<String, dynamic>,  // Ép kiểu về Map<String, dynamic>
        };
      }).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Lấy danh sách công việc theo ngày
  Future<List<Map<String, dynamic>>> fetchTasksByDate(DateTime date) async {
    final response = await http.get(Uri.parse('$baseUrl/tasks.json'));

    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> decodedResponse = json.decode(response.body);
      List<Map<String, dynamic>> tasksForDate = [];

      decodedResponse.forEach((taskId, taskData) {
        Map<String, dynamic> task = taskData as Map<String, dynamic>;

        // Kiểm tra xem ngày công việc có giống với ngày đã chọn không
        DateTime taskDate = DateFormat('EEEE, dd/MM/yyyy').parse(task['date']);
        if (taskDate.year == date.year && taskDate.month == date.month && taskDate.day == date.day) {
          tasksForDate.add({
            'id': taskId,
            ...task, // Thêm tất cả các trường khác của công việc
          });
        }
      });

      return tasksForDate;
    } else {
      throw Exception('Failed to load tasks for the selected date');
    }
  }

  // Thêm công việc mới
  Future<void> addTask(Map<String, dynamic> task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks.json'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }

  // Cập nhật công việc
  Future<void> updateTask(String id, Map<String, dynamic> task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id.json'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  // Xóa công việc
  Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id.json'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  // Thống kê công việc
  Future<Map<String, int>> fetchTaskStatistics() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks.json'));

    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> decodedResponse = json.decode(response.body);
      int completedTasks = 0;
      int newTasks = 0;
      int inProgressTasks = 0;
      int finishedTasks = 0;

      decodedResponse.forEach((taskId, taskData) {
        Map<String, dynamic> task = taskData as Map<String, dynamic>;
        // Cập nhật trạng thái công việc
        if (task['status'] == 'Thành công') {
          completedTasks++;
        } else if (task['status'] == 'Tạo mới') {
          newTasks++;
        } else if (task['status'] == 'Thực hiện') {
          inProgressTasks++;
        } else if (task['status'] == 'Kết thúc') {
          finishedTasks++;
        }
      });

      return {
        'completed': completedTasks,
        'new': newTasks,
        'inProgress': inProgressTasks,
        'finished': finishedTasks,
      };
    } else {
      throw Exception('Failed to load task statistics');
    }
  }
}
