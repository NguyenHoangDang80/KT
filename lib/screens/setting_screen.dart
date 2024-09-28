import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_provider.dart';
import 'package:mobi/service/notification_service.dart';

class SettingScreen extends StatelessWidget {
  final NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isNotificationEnabled = true; // Biến để theo dõi trạng thái bật/tắt thông báo

    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple,
    ];

    final List<String> fonts = [
      'Roboto',
      'Arial',
      'Courier New',
      'Times New Roman',
      'Comic Sans MS',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Cài Đặt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chọn Màu Chủ Đề:', style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () => themeProvider.setPrimaryColor(color),
                  child: Container(
                    color: color,
                    width: 50,
                    height: 50,
                    child: Center(child: Text(' ', style: TextStyle(color: Colors.white))),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Chọn Font Chữ:', style: TextStyle(fontSize: 20)),
            DropdownButton<String>(
              value: themeProvider.fontFamily,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  themeProvider.setFontFamily(newValue);
                }
              },
              items: fonts.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              child: Text('Chuyển Đổi Chế Độ Tối/Sáng'),
            ),
            SizedBox(height: 20),
            Text('Thiết lập nhắc nhở nhiệm vụ:', style: TextStyle(fontSize: 20)),
            SwitchListTile(
              title: Text('Bật thông báo nhắc nhở'),
              value: isNotificationEnabled,
              onChanged: (bool value) {
                // Thay đổi trạng thái thông báo
                isNotificationEnabled = value;
                if (isNotificationEnabled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thông báo nhắc nhở đã được bật!')),
                  );
                } else {
                  // Hủy tất cả thông báo nếu cần
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thông báo nhắc nhở đã được tắt!')),
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (isNotificationEnabled) {
                  DateTime scheduledTime = DateTime.now().add(Duration(seconds: 10)); // Thay đổi thời gian cho phù hợp
                  await notificationService.scheduleNotification(
                    0,
                    'Nhắc nhở nhiệm vụ',
                    'Đến lúc thực hiện nhiệm vụ của bạn!',
                    scheduledTime,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thông báo nhắc nhở đã được thiết lập!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thông báo nhắc nhở bị tắt, không thể thiết lập!')),
                  );
                }
              },
              child: Text('Thiết lập thông báo nhắc nhở'),
            ),
          ],
        ),
      ),
    );
  }
}
