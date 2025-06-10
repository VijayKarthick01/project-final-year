import 'package:collegemanaementproj/screens/HomePage.dart';
import 'package:collegemanaementproj/screens/staff_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collegemanaementproj/screens/auth_wrapper.dart';
import 'package:collegemanaementproj/screens/login.dart';
import 'package:collegemanaementproj/screens/register.dart';
import 'package:collegemanaementproj/screens/admin_dashboard.dart';
import 'package:collegemanaementproj/screens/student_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Management System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthWrapper(), // 🔥 Auto-detects role
      routes: {
        '/HomePage': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/admin-dashboard': (context) => AdminDashboard(),
        '/staff-dashboard': (context) => StaffDashboard(),
        '/student-dashboard': (context) => StudentDashboard(),
      },
    );
  }
}
