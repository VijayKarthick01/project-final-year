// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class StudentDashboard extends StatefulWidget {
//   @override
//   _StudentDashboardState createState() => _StudentDashboardState();
// }

// class _StudentDashboardState extends State<StudentDashboard>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   // Attendance
//   final TextEditingController studentIdController = TextEditingController();
//   List<dynamic> attendanceList = [];
//   bool loadingAttendance = false;

//   // Complaint form metadata & input
//   List<Map<String, dynamic>> complaintFields = [];
//   Map<String, TextEditingController> complaintControllers = {};

//   bool submittingComplaint = false;
//   // String jwtToken = ''; // Initialize empty or with your actual token
//   String? jwtToken;

//   // Events
//   List<dynamic> events = [];
//   bool loadingEvents = false;

//   final String baseUrl =
//       'http://192.168.201.189:8080/api/student'; // Change accordingly

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     fetchComplaintFormMetadata();
//     fetchEvents();
//     fetchAttendance();
//     submitComplaint();
//   }

//   // Fetch complaint form metadata
//   Future<void> fetchComplaintFormMetadata() async {
//     final response = await http.get(Uri.parse('$baseUrl/form/complaint'));
//     if (response.statusCode == 200) {
//       final List<dynamic> fields = jsonDecode(response.body);
//       setState(() {
//         complaintFields = List<Map<String, dynamic>>.from(fields);
//         complaintControllers.clear();
//         for (var field in complaintFields) {
//           complaintControllers[field['name']] = TextEditingController();
//         }
//       });
//     }
//   }

//   Future<void> fetchAttendance() async {
//     if (studentIdController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Enter Student ID')));
//       return;
//     }
//     setState(() => loadingAttendance = true);

//     final response = await http.get(
//       Uri.parse('$baseUrl/attendance/${studentIdController.text}'),
//       headers: {
//         'Authorization': 'Bearer $jwtToken', // << add this line
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         attendanceList = jsonDecode(response.body);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Failed to load attendance. Status: ${response.statusCode}',
//           ),
//         ),
//       );
//     }

//     setState(() => loadingAttendance = false);
//   }

//   Future<void> submitComplaint() async {
//     // Validate required fields
//     for (var field in complaintFields) {
//       if (field['required'] == true &&
//           (complaintControllers[field['name']]?.text.isEmpty ?? true)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${field['label']} is required')),
//         );
//         return;
//       }
//     }

//     Map<String, dynamic> body = {};
//     for (var field in complaintFields) {
//       body[field['name']] = complaintControllers[field['name']]?.text ?? '';
//     }

//     setState(() => submittingComplaint = true);

//     final response = await http.post(
//       Uri.parse('$baseUrl/complaints'),
//       headers: {
//         'Authorization': 'Bearer $jwtToken',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(body),
//     );

//     setState(() => submittingComplaint = false);

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Complaint submitted')));
//       for (var controller in complaintControllers.values) {
//         controller.clear();
//       }
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to submit complaint')));
//     }
//   }

//   // Fetch events list
//   Future<void> fetchEvents() async {
//     setState(() => loadingEvents = true);
//     final response = await http.get(Uri.parse('$baseUrl/events'));
//     if (response.statusCode == 200) {
//       setState(() {
//         events = jsonDecode(response.body);
//       });
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to load events')));
//     }
//     setState(() => loadingEvents = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Dashboard'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: 'Attendance'),
//             Tab(text: 'Complaint'),
//             Tab(text: 'Events'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // --- Attendance Tab ---
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: studentIdController,
//                   decoration: InputDecoration(
//                     labelText: 'Student ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 ElevatedButton(
//                   onPressed: loadingAttendance ? null : fetchAttendance,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child:
//                       loadingAttendance
//                           ? CircularProgressIndicator(color: Colors.white)
//                           : Text('Show Attendance'),
//                 ),
//                 SizedBox(height: 20),
//                 Expanded(
//                   child:
//                       attendanceList.isEmpty
//                           ? Text('No attendance found.')
//                           : ListView.builder(
//                             itemCount: attendanceList.length,
//                             itemBuilder: (context, index) {
//                               final att = attendanceList[index];
//                               return Card(
//                                 child: ListTile(
//                                   title: Text('Date: ${att['date'] ?? ''}'),
//                                   subtitle: Text(
//                                     'Status: ${att['status'] ?? ''}',
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                 ),
//               ],
//             ),
//           ),

//           // --- Complaint Tab ---
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child:
//                 complaintFields.isEmpty
//                     ? Center(child: CircularProgressIndicator())
//                     : SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           ...complaintFields.map((field) {
//                             final controller =
//                                 complaintControllers[field['name']]!;
//                             if (field['type'] == 'textarea') {
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 16),
//                                 child: TextField(
//                                   controller: controller,
//                                   decoration: InputDecoration(
//                                     labelText: field['label'],
//                                     hintText: field['placeholder'],
//                                     border: OutlineInputBorder(),
//                                   ),
//                                   maxLines: 5,
//                                 ),
//                               );
//                             } else {
//                               // Default to text field
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 16),
//                                 child: TextField(
//                                   controller: controller,
//                                   decoration: InputDecoration(
//                                     labelText: field['label'],
//                                     hintText: field['placeholder'],
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                               );
//                             }
//                           }).toList(),
//                           ElevatedButton(
//                             onPressed:
//                                 submittingComplaint ? null : submitComplaint,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orange,
//                               foregroundColor: Colors.white,
//                               padding: EdgeInsets.symmetric(
//                                 vertical: 14,
//                                 horizontal: 24,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child:
//                                 submittingComplaint
//                                     ? CircularProgressIndicator(
//                                       color: Colors.white,
//                                     )
//                                     : Text('Submit Complaint'),
//                           ),
//                         ],
//                       ),
//                     ),
//           ),

//           // --- Events Tab ---
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: loadingEvents ? null : fetchEvents,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child:
//                       loadingEvents
//                           ? CircularProgressIndicator(color: Colors.white)
//                           : Text('Refresh Events'),
//                 ),
//                 SizedBox(height: 16),
//                 Expanded(
//                   child:
//                       events.isEmpty
//                           ? Center(child: Text('No events found.'))
//                           : ListView.builder(
//                             itemCount: events.length,
//                             itemBuilder: (context, index) {
//                               final event = events[index];
//                               return Card(
//                                 child: ListTile(
//                                   title: Text(event['title'] ?? 'No Title'),
//                                   subtitle: Text(event['description'] ?? ''),
//                                   trailing: Text(event['date'] ?? ''),
//                                 ),
//                               );
//                             },
//                           ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     studentIdController.dispose();
//     complaintControllers.values.forEach((c) => c.dispose());
//     super.dispose();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Attendance
  final TextEditingController studentIdController = TextEditingController();
  List<Map<String, dynamic>> attendanceList = [];
  bool loadingAttendance = false;

  // Complaint form metadata & input
  List<Map<String, dynamic>> complaintFields = [];
  Map<String, TextEditingController> complaintControllers = {};

  bool submittingComplaint = false;
  String? userEmail;
  // TODO: Replace this with your actual JWT token, or manage token dynamically
  String? jwtToken;
  String? token;
  List<Map<String, dynamic>> attendanceRecords = [];
  // final TextEditingController studentIdController = TextEditingController();
  // Events
  List<dynamic> events = [];
  bool loadingEvents = false;
  // Add this to your state class
  final _complaintFormKey = GlobalKey<FormState>();
  bool loadingResponses = false;
  List<Map<String, dynamic>> complaintResponses = [];
  String? errorMessage;
  final String baseUrl =
      'http://192.168.201.189:8080/api/student'; // Change accordingly
  final String baseUrl1 =
      'http://192.168.201.189:8080/api/student-form'; // Change accordingly

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchComplaintFormMetadata();
    fetchEvents();
    fetchToken();
    fetchTokenn();
    fetchUserEmail();
    // Removed fetchAttendance() and submitComplaint() calls from initState
  }

  // Fetch complaint form metadata
  Future<void> fetchComplaintFormMetadata() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl1/student/complaint'));
      if (response.statusCode == 200) {
        final List<dynamic> fields = jsonDecode(response.body);
        setState(() {
          complaintFields = List<Map<String, dynamic>>.from(fields);
          complaintControllers.clear();
          for (var field in complaintFields) {
            complaintControllers[field['name']] = TextEditingController();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load complaint form metadata')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading complaint form metadata: $e')),
      );
    }
  }

  Future<void> fetchUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString(
        'email',
      ); // Make sure you save email during login
    });
    print("email : $userEmail");
  }

  Future<void> fetchTokenn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jwtToken = prefs.getString('jwt_token');
    });
    print("Student Token: $jwtToken"); // Debugging
  }

  Future<void> fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('jwt_token');
    });
    print("Student Token: $token"); // Debugging
  }

  Future<void> fetchAttendance() async {
    final studentId = studentIdController.text.trim();
    if (studentId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a Student ID')));
      return;
    }
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated. Please log in again.')),
      );
      return;
    }
    setState(() {
      loadingAttendance = true;
    });
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.201.189:8080/api/student/attendance/$studentId',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        setState(() {
          attendanceList = List<Map<String, dynamic>>.from(
            json.decode(response.body),
          );
        });
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unauthorized. Please log in again.')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to fetch attendance.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        loadingAttendance = false;
      });
    }
  }

  Future<void> fetchAttendance1() async {
    if (studentIdController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Enter Student ID')));
      return;
    }
    if (jwtToken == null || jwtToken!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User not authenticated')));
      return;
    }

    setState(() => loadingAttendance = true);

    print('Fetching attendance with token: $jwtToken');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attendance/${studentIdController.text}'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          attendanceList = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load attendance. Status: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching attendance: $e')));
    } finally {
      setState(() => loadingAttendance = false);
    }
  }

  Future<void> submitComplaint() async {
    print('JWT Token at submit: $jwtToken');
    if (jwtToken == null || jwtToken!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User not authenticated')));
      return;
    }

    if (!(_complaintFormKey.currentState?.validate() ?? false)) {
      return;
    }

    Map<String, dynamic> body = {};
    for (var field in complaintFields) {
      body[field['name']] = complaintControllers[field['name']]?.text ?? '';
    }

    setState(() => submittingComplaint = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/complaints'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Complaint submitted')));
        for (var controller in complaintControllers.values) {
          controller.clear();
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit complaint')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error submitting complaint: $e')));
    } finally {
      setState(() => submittingComplaint = false);
    }
  }

  Future<void> fetchComplaintResponses(String studentId) async {
    if (jwtToken == null || jwtToken!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User not authenticated')));
      return;
    }

    setState(() {
      loadingResponses = true;
      complaintResponses = [];
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/complaints/responses/$studentId'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          complaintResponses = List<Map<String, dynamic>>.from(data);
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch responses';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        loadingResponses = false;
      });
    }
  }

  // Fetch events list
  Future<void> fetchEvents() async {
    setState(() => loadingEvents = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    print("Student Token: $token"); // Debugging

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );

      if (response.statusCode == 200) {
        setState(() {
          events = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load events')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading events: $e')));
    } finally {
      setState(() => loadingEvents = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Attendance'),
            Tab(text: 'Complaint'),
            Tab(text: 'Events'),
          ],
        ),
        actions: [
          if (userEmail != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(userEmail!, style: TextStyle(fontSize: 16)),
              ),
            ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs
                  .clear(); // or remove specific keys like jwt_token, user_email
              Navigator.of(context).pushReplacementNamed(
                '/login',
              ); // Adjust route name as per your app
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // --- Attendance Tab ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: studentIdController,
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: loadingAttendance ? null : fetchAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      loadingAttendance
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Show Attendance'),
                ),
                SizedBox(height: 20),
                Expanded(
                  child:
                      attendanceList.isEmpty
                          ? Center(child: Text('No attendance found.'))
                          : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                Colors.orange.shade200,
                              ),
                              border: TableBorder.all(
                                color: Colors.orange,
                                width: 1.5,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'Student Id',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows:
                                  attendanceList.map((att) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(att['studentId'] ?? '')),

                                        DataCell(Text(att['date'] ?? '')),
                                        DataCell(Text(att['status'] ?? '')),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ),
                ),
              ],
            ),
          ),
          // In your TabBarView's Complaint tab
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Complaint Submission Form ---
                  complaintFields.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : Form(
                        key: _complaintFormKey,
                        child: Column(
                          children: [
                            ...complaintFields.map((field) {
                              final controller =
                                  complaintControllers[field['name']]!;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: TextFormField(
                                  controller: controller,
                                  maxLines: field['type'] == 'textarea' ? 5 : 1,
                                  decoration: InputDecoration(
                                    labelText: field['label'],
                                    hintText: field['placeholder'],
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (field['required'] == true &&
                                        (value == null || value.isEmpty)) {
                                      return '${field['label']} is required';
                                    }
                                    return null;
                                  },
                                ),
                              );
                            }).toList(),
                            ElevatedButton(
                              onPressed:
                                  submittingComplaint
                                      ? null
                                      : () async {
                                        if (_complaintFormKey.currentState
                                                ?.validate() ??
                                            false) {
                                          await submitComplaint();
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                                  submittingComplaint
                                      ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text('Submit Complaint'),
                            ),
                          ],
                        ),
                      ),

                  SizedBox(height: 40),

                  // --- Section to View Complaint Responses ---
                  Text(
                    'View Complaint Responses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  TextField(
                    controller: studentIdController,
                    decoration: InputDecoration(
                      labelText: 'Enter Student ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed:
                        loadingResponses
                            ? null
                            : () {
                              final studentId = studentIdController.text.trim();
                              if (studentId.isNotEmpty) {
                                fetchComplaintResponses(studentId);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter a Student ID'),
                                  ),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        loadingResponses
                            ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                            : Text('Show Responses'),
                  ),
                  SizedBox(height: 20),

                  if (errorMessage != null)
                    Text(errorMessage!, style: TextStyle(color: Colors.red)),

                  complaintResponses.isEmpty
                      ? Text('No responses to display.')
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: complaintResponses.length,
                        itemBuilder: (context, index) {
                          final complaint = complaintResponses[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(
                                'Complaint: ${complaint['message'] ?? 'N/A'}',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 6),
                                  // Text(
                                  //   'Status: ${complaint['status'] ?? 'N/A'}',
                                  // ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Staff Response: ${complaint['response'] ?? 'No response yet'}',
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Submitted At: ${complaint['submittedAt'] ?? 'N/A'}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Column(
          //     children: [
          //       TextField(
          //         controller: studentIdController,
          //         decoration: InputDecoration(
          //           labelText: 'Student ID',
          //           border: OutlineInputBorder(),
          //         ),
          //       ),
          //       SizedBox(height: 12),
          //       ElevatedButton(
          //         onPressed: loadingAttendance ? null : fetchAttendance,
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Colors.orange,
          //           foregroundColor: Colors.white,
          //           padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12),
          //           ),
          //         ),
          //         child:
          //             loadingAttendance
          //                 ? SizedBox(
          //                   width: 22,
          //                   height: 22,
          //                   child: CircularProgressIndicator(
          //                     color: Colors.white,
          //                     strokeWidth: 2.5,
          //                   ),
          //                 )
          //                 : Text('Show Attendance'),
          //       ),
          //       SizedBox(height: 20),
          //       Expanded(
          //         child:
          //             attendanceList.isEmpty
          //                 ? Text('No attendance found.')
          //                 : ListView.builder(
          //                   itemCount: attendanceList.length,
          //                   itemBuilder: (context, index) {
          //                     final att = attendanceList[index];
          //                     return Card(
          //                       child: ListTile(
          //                         title: Text('Date: ${att['date'] ?? ''}'),
          //                         subtitle: Text(
          //                           'Status: ${att['status'] ?? ''}',
          //                         ),
          //                       ),
          //                     );
          //                   },
          //                 ),
          //       ),
          //     ],
          //   ),
          // ),
          // --- Events Tab ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: loadingEvents ? null : fetchEvents,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      loadingEvents
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Refresh Events'),
                ),
                SizedBox(height: 16),
                Expanded(
                  child:
                      events.isEmpty
                          ? Center(child: Text('No events found.'))
                          : ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              return Card(
                                child: ListTile(
                                  title: Text(event['title'] ?? 'No Title'),
                                  subtitle: Text(event['description'] ?? ''),
                                  trailing: Text(event['date'] ?? ''),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    studentIdController.dispose();
    complaintControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }
}
