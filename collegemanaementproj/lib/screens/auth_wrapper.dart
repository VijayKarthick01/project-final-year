// import 'package:collegemanaementproj/screens/Login.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'admin_dashboard.dart';
// import 'student_dashboard.dart';
// // import 'login_screen.dart';

// class AuthWrapper extends StatefulWidget {
//   @override
//   _AuthWrapperState createState() => _AuthWrapperState();
// }

// class _AuthWrapperState extends State<AuthWrapper> {
//   String? role;

//   @override
//   void initState() {
//     super.initState();
//     _checkRole();
//   }

//   Future<void> _checkRole() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedRole = prefs.getString('user_role');

//     if (storedRole != null) {
//       storedRole = storedRole
//           .trim()
//           .replaceAll(RegExp(r'\s+'), '')
//           .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');
//       debugPrint("🔍 Extracted Role: '$storedRole'");
//       debugPrint("🔤 ASCII Values: ${storedRole.codeUnits}");
//     }

//     setState(() {
//       role = storedRole;
//     });

//     debugPrint(
//       "✅ Expected Role: 'ROLE_ADMIN' (ASCII: ${'ROLE_ADMIN'.codeUnits})",
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (role == null || role!.trim().isEmpty) {
//       return LoginPage();
//     }

//     String normalizedRole = role!.trim();

//     debugPrint(
//       "✅ Extracted Role: '$normalizedRole' (ASCII: ${normalizedRole.codeUnits})",
//     );

//     switch (normalizedRole) {
//       case 'ROLE_ADMIN':
//         return AdminDashboard();
//       case 'ROLE_STUDENT':
//         return StudentDashboard();
//       default:
//         debugPrint(
//           "❌ Unknown role detected: '$normalizedRole' (ASCII: ${normalizedRole.codeUnits})",
//         );
//         return LoginPage();
//     }
//   }
// }
////

// import 'package:collegemanaementproj/screens/Login.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'admin_dashboard.dart';
// import 'student_dashboard.dart';

// class AuthWrapper extends StatefulWidget {
//   @override
//   _AuthWrapperState createState() => _AuthWrapperState();
// }

// class _AuthWrapperState extends State<AuthWrapper> {
//   String? role;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _checkRole();
//   }

//   Future<void> _checkRole() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedRole = prefs.getString('user_role');

//     if (storedRole != null) {
//       storedRole = storedRole
//           .trim()
//           .replaceAll(RegExp(r'\s+'), '')
//           .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');
//       debugPrint("🔍 Extracted Role: '$storedRole'");
//       debugPrint("🔤 ASCII Values: ${storedRole.codeUnits}");
//     }

//     if (!mounted) return;  // ADDED: Check the widget is mounted
//     setState(() {
//       role = storedRole;
//       _isLoading = false;  // Set loading to false once checked
//     });

//     debugPrint(
//       "✅ Expected Role: 'ROLE_ADMIN' (ASCII: ${'ROLE_ADMIN'.codeUnits})",
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (role == null || role!.trim().isEmpty) {
//       return LoginPage();
//     }

//     String normalizedRole = role!.trim();

//     debugPrint(
//       "✅ Extracted Role: '$normalizedRole' (ASCII: ${normalizedRole.codeUnits})",
//     );

//     switch (normalizedRole) {
//       case 'ROLE_ADMIN':
//         return AdminDashboard();
//       case 'ROLE_STUDENT':
//         return StudentDashboard();
//       default:
//         debugPrint(
//           "❌ Unknown role detected: '$normalizedRole' (ASCII: ${normalizedRole.codeUnits})",
//         );
//         return LoginPage();
//     }
//   }
// }

import 'package:collegemanaementproj/screens/HomePage.dart';
import 'package:collegemanaementproj/screens/Login.dart';
import 'package:collegemanaementproj/screens/staff_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_dashboard.dart';
import 'student_dashboard.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String? role;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedRole = prefs.getString('user_role');

    if (storedRole != null) {
      storedRole = storedRole
          .trim()
          .replaceAll(RegExp(r'\s+'), '')
          .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');
      debugPrint("🔍 Extracted Role: '$storedRole'");
      debugPrint("🔤 ASCII Values: ${storedRole.codeUnits}");
    }

    if (!mounted) return;
    setState(() {
      role = storedRole;
    });

    debugPrint(
      "✅ Expected Role: 'ROLE_ADMIN' (ASCII: ${'ROLE_ADMIN'.codeUnits})",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (role == null || role!.trim().isEmpty) {
      return HomePage();
    }

    String normalizedRole = role!.trim();

    debugPrint(
      "✅ Extracted Role: '$normalizedRole' (ASCII: ${normalizedRole.codeUnits})",
    );

    switch (normalizedRole) {
      
      case 'ROLE_ADMIN':
        return AdminDashboard();
      case 'STUDENT':
        return StudentDashboard();
      case 'STAFF':
        return StaffDashboard();
      default:
        debugPrint(
          "❌ Unknown role detected: '$normalizedRole' (ASCII: ${normalizedRole.codeUnits})",
        );
        return HomePage();
    }
  }
}
