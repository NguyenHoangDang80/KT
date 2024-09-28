import 'package:flutter/material.dart';
import 'package:mobi/service/api_service.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart'; 
import 'edit_task_screen.dart'; 
import 'package:intl/intl.dart'; // Thêm thư viện để định dạng ngày

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> tasks = []; // Đảm bảo kiểu dữ liệu là List<Map<String, dynamic>>

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      final fetchedTasks = await apiService.fetchTasks();
      setState(() {
        tasks = fetchedTasks.isNotEmpty ? fetchedTasks : []; // Nếu không có dữ liệu, khởi tạo là danh sách rỗng
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void navigateToAddTaskScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()), // Chuyển tới màn hình thêm công việc
    ).then((_) {
      fetchTasks(); // Lấy lại danh sách công việc sau khi quay lại từ màn hình thêm công việc
    });
  }

  void navigateToDetailScreen(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );
  }

  void navigateToEditTaskScreen(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
    ).then((updated) {
      if (updated != null && updated) {
        fetchTasks(); // Lấy lại danh sách công việc nếu có thay đổi
      }
    });
  }

  Future<void> deleteTask(String id) async {
    // Hiển thị hộp thoại xác nhận trước khi xóa
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa công việc này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await apiService.deleteTask(id);
                  fetchTasks(); // Lấy lại danh sách sau khi xóa
                  Navigator.of(context).pop(); // Đóng hộp thoại sau khi xóa
                } catch (e) {
                  print('Error deleting task: $e');
                }
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateTaskOrder(List<Map<String, dynamic>> updatedTasks) async {
    for (var task in updatedTasks) {
      await apiService.updateTask(task['id'], task); // Cập nhật từng task
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Công Việc'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddTaskScreen, // Gọi hàm điều hướng
            tooltip: 'Thêm công việc', // Thêm tooltip cho nút
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(child: Text('Không có công việc')) // Hiển thị thông báo nếu không có công việc
          : ReorderableListView.builder(
              itemCount: tasks.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1; // Điều chỉnh chỉ số nếu kéo xuống
                  }
                  final task = tasks.removeAt(oldIndex);
                  tasks.insert(newIndex, task); // Thay đổi thứ tự danh sách

                  // Cập nhật thứ tự công việc trên server
                  updateTaskOrder(tasks);
                });
              },
              itemBuilder: (context, index) {
                final task = tasks[index];
                // Định dạng ngày công việc
                String taskDate = task['date'] != null
                    ? DateFormat('EEEE, dd/MM/yyyy').format(DateFormat('EEEE, dd/MM/yyyy').parse(task['date']))
                    : 'Chưa có ngày';
                return ListTile(
                  key: ValueKey(task['id']), // Đảm bảo mỗi mục có một key duy nhất
                  title: Text(task['name'] ?? 'Unnamed Task'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ngày: $taskDate'), // Hiển thị ngày của công việc
                      Text('Trạng thái: ${task['status'] ?? 'Chưa xác định'}'), // Hiển thị trạng thái công việc
                    ],
                  ),
                  onTap: () => navigateToDetailScreen(task), // Chuyển đến chi tiết công việc
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => navigateToEditTaskScreen(task), // Cập nhật công việc
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(task['id']), // Gọi hàm xóa công việc
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
