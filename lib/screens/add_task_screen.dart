import 'package:flutter/material.dart';
import 'package:mobi/service/api_service.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  String taskName = '';
  String taskStatus = 'Tạo mới';
  String taskLocation = '';
  String taskLeader = '';
  String taskNotes = '';
  DateTime? taskDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> saveTask() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> newTask = {
        'name': taskName,
        'status': taskStatus,
        'location': taskLocation,
        'leader': taskLeader,
        'notes': taskNotes,
        'date': taskDate != null ? DateFormat('EEEE, dd/MM/yyyy').format(taskDate!) : null,
        'start_time': startTime != null ? startTime!.format(context) : null,
        'end_time': endTime != null ? endTime!.format(context) : null,
      };

      try {
        await apiService.addTask(newTask);
        Navigator.pop(context, true);
      } catch (e) {
        print('Error saving task: $e');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != taskDate) {
      setState(() {
        taskDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Công Việc Mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Tên Công Việc'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên công việc';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    taskName = value;
                  });
                },
              ),
              DropdownButtonFormField(
                value: taskStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    taskStatus = newValue!;
                  });
                },
                items: <String>['Tạo mới', 'Thực hiện', 'Thành công', 'Kết thúc']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Trạng Thái'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Địa Điểm'),
                onChanged: (value) {
                  setState(() {
                    taskLocation = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Người Phụ Trách'),
                onChanged: (value) {
                  setState(() {
                    taskLeader = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ghi Chú'),
                onChanged: (value) {
                  setState(() {
                    taskNotes = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(taskDate != null ? DateFormat('EEEE, dd/MM/yyyy').format(taskDate!) : 'Chọn Ngày'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(startTime != null ? startTime!.format(context) : 'Chọn Giờ Bắt Đầu'),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectStartTime(context),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(endTime != null ? endTime!.format(context) : 'Chọn Giờ Kết Thúc'),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectEndTime(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveTask,
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
