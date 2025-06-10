import 'package:collegemanaementproj/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String baseUrl = 'http://192.168.201.189:8080/api';
  final Map<String, TextEditingController> controllers = {};
  final Map<String, bool> obscureText = {};
  List<Map<String, dynamic>> formFields = [];

  @override
  void initState() {
    super.initState();
    fetchFormMetadata();
  }

  Future<void> fetchFormMetadata() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/form-metadata/register'),
      );

      if (response.statusCode == 200) {
        setState(() {
          formFields = List<Map<String, dynamic>>.from(
            json.decode(response.body),
          );

          for (var field in formFields) {
            String fieldName = field['fieldName'] ?? field['name'];
            if (fieldName != null) {
              controllers[fieldName] = TextEditingController();
              if (field['type'] == 'password') {
                obscureText[fieldName] = true; // Default hide passwords
              }
            }
          }
        });
      } else {
        throw Exception("Failed to load form metadata");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error loading form",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<void> registerUser() async {
    Map<String, String> formData = {};
    for (var field in formFields) {
      String fieldName = field['fieldName'] ?? field['name'];
      if (fieldName != null) {
        formData[fieldName] = controllers[fieldName]?.text ?? '';
      }
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.statusCode == 200
                ? "Registration Successful!"
                : "Registration Failed!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor:
              response.statusCode == 200 ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error occurred!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget buildFormField(Map<String, dynamic> field) {
    String fieldName = field['fieldName'] ?? field['name'];
    if (fieldName == null) return SizedBox();

    bool isPasswordField = field['type'] == 'password';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child:
          isPasswordField
              ? TextField(
                controller: controllers[fieldName],
                obscureText: obscureText[fieldName]!,
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: field['label'],
                  labelStyle: TextStyle(color: Colors.black87),
                  hintText: field['hint'],
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(137, 12, 11, 11),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText[fieldName]!
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText[fieldName] = !obscureText[fieldName]!;
                      });
                    },
                  ),
                ),
              )
              : field['type'] == 'dropdown'
              ? DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: field['label'],
                  labelStyle: TextStyle(color: Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                dropdownColor: Colors.grey[100],
                value:
                    controllers[fieldName]?.text.isNotEmpty == true
                        ? controllers[fieldName]?.text
                        : null,
                items:
                    (field['options'] as List<dynamic>)
                        .map<DropdownMenuItem<String>>((option) {
                          return DropdownMenuItem<String>(
                            value: option.toString(),
                            child: Text(
                              option.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        })
                        .toList(),
                onChanged: (newValue) {
                  setState(() {
                    controllers[fieldName]?.text = newValue!;
                  });
                },
              )
              : TextField(
                controller: controllers[fieldName],
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: field['label'],
                  labelStyle: TextStyle(color: Colors.black87),
                  hintText: field['hint'],
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(137, 22, 20, 20),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
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
                  ElevatedButton(
                    onPressed: registerUser,
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
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
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
