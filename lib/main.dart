import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_login_screen.dart';
import 'screens/task_list_screen.dart';
import 'models/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: DailyPlannerApp(),
    ),
  );
}

class DailyPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Daily Planner',
          theme: ThemeData(
            primaryColor: themeProvider.primaryColor,
            fontFamily: themeProvider.fontFamily,
            brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => WelcomeLoginScreen(),
            '/task-list': (context) => TaskListScreen(),
          },
        );
      },
    );
  }
}
