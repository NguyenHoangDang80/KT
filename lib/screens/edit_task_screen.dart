import 'package:flutter/material.dart';
import 'package:mobi/service/api_service.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController ownerController;
  late TextEditingController notesController;

  late String status;
  late DateTime? taskDate;
  late TimeOfDay? startTime;
  late TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.task['name']);
    locationController = TextEditingController(text: widget.task['location']);
    ownerController = TextEditingController(text: widget.task['leader']);
    notesController = TextEditingController(text: widget.task['notes']);
    status = widget.task['status'];
    taskDate = DateFormat('EEEE, dd/MM/yyyy').parse(widget.task['date']);
    startTime = TimeOfDay.now(); // Cần cập nhật giá trị khởi tạo
    endTime = TimeOfDay.now(); // Cần cập nhật giá trị khởi tạo
  }

  Future<void> updateTask() async {
    Map<String, dynamic> updatedTask = {
      'name': nameController.text,
      'location': locationController.text,
      'leader': ownerController.text,
      'notes': notesController.text,
      'status': status,
      'date': taskDate != null ? DateFormat('EEEE, dd/MM/yyyy').format(taskDate!) : null,
      'start_time': startTime != null ? startTime!.format(context) : null,
      'end_time': endTime != null ? endTime!.format(context) : null,
    };

    try {
      await apiService.updateTask(widget.task['id'], updatedTask);
      Navigator.pop(context, true);
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: taskDate!,
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
        title: Text('Chỉnh Sửa Công Việc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên Công Việc'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên công việc';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: status,
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue!;
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
                controller: locationController,
                decoration: InputDecoration(labelText: 'Địa Điểm'),
              ),
              TextFormField(
                controller: ownerController,
                decoration: InputDecoration(labelText: 'Người Phụ Trách'),
              ),
              TextFormField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'Ghi Chú'),
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
                onPressed: updateTask,
                child: Text('Cập Nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
