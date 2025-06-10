import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collegemanaementproj/screens/admin_dashboard.dart';
import 'package:collegemanaementproj/screens/student_dashboard.dart';
import 'package:collegemanaementproj/screens/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final String baseUrl = 'http://192.168.201.189:8080/api';
  final Map<String, TextEditingController> controllers = {};
  List<Map<String, dynamic>> formFields = [];
  bool isLoading = false;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    fetchFormMetadata();

    // Animation setup for the login button
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> fetchFormMetadata() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/form-metadata/login'),
      );

      if (!mounted) return; // Check if widget is mounted before setState.

      if (response.statusCode == 200) {
        setState(() {
          formFields = List<Map<String, dynamic>>.from(
            json.decode(response.body),
          );
          for (var field in formFields) {
            controllers[field['fieldName']] = TextEditingController();
          }
        });
      } else {
        if (!mounted)
          return; // Handle error and make sure the widget is mounted
        showSnackBar("Failed to load form metadata");
      }
    } catch (e) {
      if (!mounted) return; // Error handling, check the widget is mounted
      showSnackBar("Error loading form: $e"); // Added exception to message
    }
  }

  Future<void> loginUser() async {
    if (!mounted) return;

    Map<String, String> formData = {};
    for (var field in formFields) {
      formData[field['fieldName']] = controllers[field['fieldName']]!.text;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      if (!mounted) return;

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String? token = responseData['token'];
        String? role = responseData['role'];

        print("Extracted Token: $token");
        print("Extracted Role: $role");

        if (token == null || role == null) {
          showSnackBar("Invalid response from server!");
          return;
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('user_role', role);

        showSnackBar("Login Successful!");

        // 🔁 Navigation based on role
        if (role == 'ROLE_ADMIN') {
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
        } else if (role == 'STAFF') {
          Navigator.pushReplacementNamed(context, '/staff-dashboard');
        } else if (role == 'STUDENT') {
          Navigator.pushReplacementNamed(context, '/student-dashboard');
        } else {
          showSnackBar("Unknown role, contact support!");
        }
      } else if (response.statusCode == 401) {
        final json = jsonDecode(response.body);
        final message = json['message'];

        if (message ==
            "Your account is blocked. Please contact the administrator.") {
          print("Your account is blocked");
          showSnackBar("Your account is blocked");
        } else if (message == "Invalid email or password.") {
          print("Invalid email or password");
          showSnackBar("Invalid email or password");
        } else {
          showSnackBar("Unauthorized: $message");
        }
      } else {
        showSnackBar("Login Failed! Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
      showSnackBar("Error occurred! Try again. $e");
    }
  }

  void showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // final Map<String, TextEditingController> controllers = {};
  final Map<String, bool> obscureText = {}; // State for password visibility
  // Widget buildFormField(Map<String, dynamic> field) {
  //   bool isPasswordField = field['type'] == 'password';
  //   obscureText.putIfAbsent(
  //     field['fieldName'],
  //     () => isPasswordField,
  //   ); // Default state

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: TextField(
  //       controller: controllers[field['fieldName']],
  //       obscureText: isPasswordField ? obscureText[field['fieldName']]! : false,
  //       style: TextStyle(color: Colors.white), // White text for dark mode
  //       decoration: InputDecoration(
  //         labelText: field['label'],
  //         labelStyle: TextStyle(color: Colors.white70),
  //         hintText: field['hint'],
  //         hintStyle: TextStyle(color: Colors.white54),
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //         filled: true,
  //         fillColor: Colors.grey.shade700, // Dark field background
  //         contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //         suffixIcon:
  //             isPasswordField
  //                 ? IconButton(
  //                   icon: Icon(
  //                     obscureText[field['fieldName']]!
  //                         ? Icons.visibility_off
  //                         : Icons.visibility,
  //                     color: Colors.white70,
  //                   ),
  //                   onPressed: () {
  //                     setState(() {
  //                       obscureText[field['fieldName']] =
  //                           !obscureText[field['fieldName']]!;
  //                     });
  //                   },
  //                 )
  //                 : null,
  //       ),
  //     ),
  //   );
  // }
  Widget buildFormField(Map<String, dynamic> field) {
    bool isPasswordField = field['type'] == 'password';
    obscureText.putIfAbsent(field['fieldName'], () => isPasswordField);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controllers[field['fieldName']],
        obscureText: isPasswordField ? obscureText[field['fieldName']]! : false,
        style: TextStyle(color: Colors.black87), // Dark text
        decoration: InputDecoration(
          labelText: field['label'],
          labelStyle: TextStyle(color: Colors.black54),
          hintText: field['hint'],
          hintStyle: TextStyle(color: Colors.black38),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100], // Light field background
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          suffixIcon:
              isPasswordField
                  ? IconButton(
                    icon: Icon(
                      obscureText[field['fieldName']]!
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText[field['fieldName']] =
                            !obscureText[field['fieldName']]!;
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE6E6FA), // light lavender
              Color(0xFFD1F3FF), // light blue
              Color(0xFFFDF6F0), // light cream
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(28),
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95), // Light card
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  formFields.isEmpty
                      ? CircularProgressIndicator()
                      : Column(
                        children:
                            formFields
                                .map((field) => buildFormField(field))
                                .toList(),
                      ),
                  SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _buttonAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _buttonAnimation.value,
                        child: ElevatedButton(
                          onPressed: () {
                            _buttonController.forward();
                            loginUser();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 40,
                            ),
                            shape: StadiumBorder(),
                            elevation: 4,
                            backgroundColor: Color(0xFF00C3A5), // Green accent
                            shadowColor: Colors.blueGrey.shade100,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
