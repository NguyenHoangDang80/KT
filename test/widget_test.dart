import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobi/main.dart'; // Chỉnh sửa lại import nếu cần thiết.

void main() {
  testWidgets('Welcome screen and login navigation test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(DailyPlannerApp());

    // Verify that Welcome screen is displayed with 'Welcome to Daily Planner' text.
    expect(find.text('Welcome to Daily Planner'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Tap the 'Login' button and trigger a frame.
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify that the login screen is displayed.
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('Task List screen displays and navigates correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(DailyPlannerApp());

    // Simulate successful login by navigating directly to Task List screen.
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify the Task List screen is displayed.
    expect(find.text('Danh Sách Công Việc'), findsOneWidget); // Kiểm tra tên màn hình Task List
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the '+' icon to add a new task.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the add task screen is shown.
    expect(find.text('Thêm Công Việc'), findsOneWidget);
    expect(find.text('Nội Dung'), findsOneWidget);
  });

  testWidgets('Calendar screen displays correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(DailyPlannerApp());

    // Simulate successful login by navigating directly to Task List screen.
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Navigate to the Calendar screen using the bottom navigation bar.
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();

    // Verify the Calendar screen is displayed.
    expect(find.text('Lịch'), findsOneWidget); // Kiểm tra tên màn hình Calendar
  });

  testWidgets('Task Detail screen navigates correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(DailyPlannerApp());

    // Simulate successful login by navigating directly to Task List screen.
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Navigate to the Task List screen.
    expect(find.text('Danh Sách Công Việc'), findsOneWidget);

    // Simulate tapping on a task to view details (assuming a task is listed).
    await tester.tap(find.text('Unnamed Task')); // Thay đổi tên này với tên task phù hợp
    await tester.pumpAndSettle();

    // Verify that the Task Detail screen is displayed.
    expect(find.text('Công Việc'), findsOneWidget); // Kiểm tra tiêu đề Task Detail
  });
}
