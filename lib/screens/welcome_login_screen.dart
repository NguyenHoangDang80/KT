import 'package:flutter/material.dart';
import 'package:mobi/screens/dashboard_screen.dart';

class WelcomeLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Đặt màu nền là xanh da trời nhạt
      backgroundColor: Color(0xFFADD8E6), // Mã màu cho xanh da trời nhạt
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị ảnh logo.jpg từ thư mục assets/images
            Image.asset('assets/images/logo.jpg',
            width: 200, // Thay đổi kích thước logo
              height: 200),
            SizedBox(height: 40),
            
            // TextField để nhập email
            TextField(
              decoration: InputDecoration(labelText: 'Email sinh viên'),
            ),
            
            // TextField để nhập mật khẩu
            TextField(
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20),

            // Nút Đăng nhập
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );// Xử lý logic đăng nhập
              },
              child: Text('Đăng nhập'),
            ),

            SizedBox(height: 20),

            // Dòng thông tin bổ sung hoặc liên kết
            ElevatedButton(
              onPressed: () {
                // Thêm logic khi cần, ví dụ: forgot password, support
              },
              child: Text('Quên mật khẩu?'),
            ),
          ],
        ),
      ),
    );
  }
}
