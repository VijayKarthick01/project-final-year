import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://192.168.201.189:8080/api/staff';

class StaffDashboard extends StatefulWidget {
  @override
  _StaffDashboardState createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  List<Map<String, dynamic>> attendanceFormFields = [];
  List<Map<String, dynamic>> complaintResponseFormFields = [];
  List<Map<String, dynamic>> eventFormFields = [];
  List<Map<String, dynamic>> attendanceRecords = [];
  List<Map<String, dynamic>> complaints = [];
  final Map<String, TextEditingController> controllers = {};
  String? selectedAttendanceId;
  bool showEventsList = false; // Controls visibility of events list
  List<Map<String, dynamic>> events = []; // Holds fetched events
  String? token;
  final TextEditingController updateStudentIdController =
      TextEditingController();
  final TextEditingController updateDateController = TextEditingController();
  final TextEditingController updateSectionController = TextEditingController();
  String updateStatus = 'Present';

  final List<String> statusOptions = ['Present', 'Absent', 'Late'];
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  String? selectedStatus;
  String? selectedSection = 'Attendance';
  void populateUpdateFields(Map<String, dynamic> record) {
    setState(() {
      updateStudentIdController.text = record['studentId'];
      updateDateController.text = record['date'];
      updateSectionController.text = record['section'];
      updateStatus = record['status'];
      selectedAttendanceId = record['id']; // Store the actual record ID here
    });
  }

  Widget buildFormField(Map<String, dynamic> field) {
    final fieldName = field['name'];

    final labelStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.grey[800],
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
    );

    switch (field['type']) {
      case 'text':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            controller: controllers[fieldName],
            decoration: InputDecoration(
              labelText: field['label'],
              labelStyle: labelStyle,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              border: inputBorder,
              focusedBorder: focusedBorder,
              errorBorder: inputBorder.copyWith(
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: focusedBorder.copyWith(
                borderSide: BorderSide(color: Colors.redAccent, width: 2),
              ),
            ),
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'This field is required'
                        : null,
            onSaved: (value) => formData[fieldName] = value,
            style: TextStyle(fontSize: 16, color: Colors.grey[900]),
          ),
        );

      case 'date':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate:
                    controllers[fieldName]?.text.isNotEmpty == true
                        ? DateTime.tryParse(controllers[fieldName]!.text) ??
                            DateTime.now()
                        : DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                String formattedDate =
                    pickedDate.toIso8601String().split('T')[0];
                setState(() {
                  controllers[fieldName]?.text = formattedDate;
                  formData[fieldName] = formattedDate;
                });
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controllers[fieldName],
                decoration: InputDecoration(
                  labelText: field['label'],
                  labelStyle: labelStyle,
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  border: inputBorder,
                  focusedBorder: focusedBorder,
                  errorBorder: inputBorder.copyWith(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                  focusedErrorBorder: focusedBorder.copyWith(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2),
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.grey[600],
                  ),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'This field is required'
                            : null,
                style: TextStyle(fontSize: 16, color: Colors.grey[900]),
              ),
            ),
          ),
        );

      case 'textarea':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            controller: controllers[fieldName],
            decoration: InputDecoration(
              labelText: field['label'],
              labelStyle: labelStyle,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
              border: inputBorder,
              focusedBorder: focusedBorder,
              errorBorder: inputBorder.copyWith(
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: focusedBorder.copyWith(
                borderSide: BorderSide(color: Colors.redAccent, width: 2),
              ),
            ),
            maxLines: 5,
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'This field is required'
                        : null,
            onSaved: (value) => formData[fieldName] = value,
            style: TextStyle(fontSize: 16, color: Colors.grey[900]),
          ),
        );

      case 'dropdown':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: DropdownButtonFormField<String>(
            value:
                formData[fieldName]?.isEmpty ?? true
                    ? null
                    : formData[fieldName],
            decoration: InputDecoration(
              labelText: field['label'],
              labelStyle: labelStyle,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              border: inputBorder,
              focusedBorder: focusedBorder,
              errorBorder: inputBorder.copyWith(
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: focusedBorder.copyWith(
                borderSide: BorderSide(color: Colors.redAccent, width: 2),
              ),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
            ),
            items:
                (field['options'] as List).map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option, style: TextStyle(fontSize: 16)),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() => formData[fieldName] = value);
            },
            validator:
                (value) => value == null ? 'Please select an option' : null,
            style: TextStyle(fontSize: 16, color: Colors.grey[900]),
            dropdownColor: Colors.white,
            isExpanded: true,

            // Hide default dropdown arrow to avoid duplicate arrows
            icon: SizedBox.shrink(),
          ),
        );

      default:
        return SizedBox.shrink();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchToken();
    initializeControllers;
  }

  Future<void> fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('jwt_token');
    });
    print("Retrieved Token: $token"); // Debugging

    if (token != null) {
      fetchAttendanceFormFields();
      fetchComplaintResponseFormFields();
      fetchEventFormFields();
      fetchComplaints();
      fetchEvents();
      respondToComplaint;
    }
  }

  void initializeControllers(List<Map<String, dynamic>> fields) {
    for (var field in fields) {
      final fieldName = field['name'];
      if (!controllers.containsKey(fieldName)) {
        controllers[fieldName] = TextEditingController();
        formData[fieldName] = ''; // Initialize with empty string
      }
    }
  }

  Future<void> fetchAttendanceFormFields() async {
    if (token == null) return;
    final response = await http.get(
      Uri.parse('$baseUrl/forms/attendance'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        attendanceFormFields = List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
        initializeControllers(attendanceFormFields); // Initialize here
      });
    }
  }

  //field
  Future<void> fetchComplaintResponseFormFields() async {
    if (token == null) return;
    final response = await http.get(
      Uri.parse('$baseUrl/forms/complaint-response'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        complaintResponseFormFields = List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
      });
      print("Updated Complaint Form Fields: $complaintResponseFormFields");
    }
  }

  //field
  Future<void> fetchEventFormFields() async {
    if (token == null) return;
    final response = await http.get(
      Uri.parse('$baseUrl/forms/event'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        eventFormFields = List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
      });
      print("Updated Event Form Fields: $eventFormFields");
    }
  }

  Future<void> fetchAttendanceByDateAndSection(
    String date,
    String section,
  ) async {
    if (token == null) return;
    final response = await http.get(
      Uri.parse(
        '$baseUrl/attendance/by-date-section?date=$date&section=$section',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        attendanceRecords = List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
      });
      print("🔍 Date: ${dateController.text}");
      print("🔍 Section: $selectedSectionDropdown");
      print("🔍 Student ID: ${studentIdController.text}");

      print("📌 Filtered Attendance: $attendanceRecords");
    }
  }

  Future<void> updateAttendance(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    if (token == null) return;

    final response = await http.put(
      Uri.parse('$baseUrl/attendance/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(updatedData),
    );

    print('Update response status: ${response.statusCode}');
    print('Update response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Attendance updated successfully')),
      );
      // Optionally refresh your attendance list here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to update attendance: ${response.body}'),
        ),
      );
    }
  }

  //addattendance
  Future<void> submitAttendance() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // This now captures all values
      print('Form Data Before Submission: $formData');
      // Remove the manual controller handling here
      final dataToSend = {
        "studentId": formData["studentId"],
        "date": formData["date"],
        "status": formData["status"],
        "section": formData["section"],
        "_class": "com.example.ProjectFinalYear.model.Attendance",
      };

      print("Sending: $dataToSend");

      final response = await http.post(
        Uri.parse('$baseUrl/attendance/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(dataToSend),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Attendance added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to add attendance: ${response.body}'),
          ),
        );
      }
    } else {
      print("Validation failed");
    }
  }

  Future<void> viewStudentAttendance(String studentId) async {
    if (token == null) return;
    final response = await http.get(
      Uri.parse('$baseUrl/attendance/view/$studentId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        attendanceRecords = List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
      });
      print("👨‍🎓 Student Attendance: $attendanceRecords");
      print("🔍 Date: ${dateController.text}");
      print("🔍 Section: $selectedSectionDropdown");

      print("🔍 Student ID: ${studentIdController.text}");
    }
  }

  //getcomplaints
  Future<void> fetchComplaints() async {
    if (token == null) return;
    final response = await http.get(
      Uri.parse('$baseUrl/complaints'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        complaints = List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
      });
    }
  }

  Future<void> respondToComplaint(String id, String responseText) async {
    if (token == null) return;
    final response = await http.post(
      Uri.parse('$baseUrl/complaints/respond/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(responseText),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Complaint responded successfully')),
      );
      fetchComplaints(); // Refresh complaints list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to respond: ${response.body}')),
      );
    }
  }

  //getevents
  Future<void> fetchEvents() async {
    if (token == null) return;
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        events = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // Handle error
      print('Failed to fetch events: ${response.statusCode}');
    }
  }

  Future<void> submitEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final eventData = <String, dynamic>{};
      for (var field in eventFormFields) {
        eventData[field['name']] = formData[field['name']];
      }

      final response = await http.post(
        Uri.parse('$baseUrl/events/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(eventData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Event created successfully')));
        await fetchEvents();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create event')));
      }
    }
  }

  final TextEditingController dateController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  String? selectedSectionDropdown;
  final List<String> sectionOptions = ['A', 'B', 'C']; // Add more if needed

  Widget buildSectionContent() {
    if (selectedSection == 'Attendance') {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📝 Submit Attendance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            buildDynamicForm(
              attendanceFormFields,
              'Submit Attendance',
              submitAttendance,
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[500],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 30),
            Divider(),
            Text(
              "📌 Attendance Tools",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            SizedBox(height: 16),

            // Date Picker Field
            GestureDetector(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text =
                        pickedDate.toIso8601String().split('T')[0];
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            // Section Dropdown
            DropdownButtonFormField<String>(
              value: selectedSectionDropdown,
              decoration: InputDecoration(
                labelText: 'Select Section',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              items:
                  sectionOptions.map((section) {
                    return DropdownMenuItem(
                      value: section,
                      child: Text(section),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSectionDropdown = value;
                });
              },
            ),

            SizedBox(height: 16),

            // Fetch Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (dateController.text.isNotEmpty &&
                      selectedSectionDropdown != null) {
                    fetchAttendanceByDateAndSection(
                      dateController.text,
                      selectedSectionDropdown!,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter date and section')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[500],
                  foregroundColor:
                      Colors.white, // Ensures default text/icon is white
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Fetch by Date & Section",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Student ID Input
            TextFormField(
              controller: studentIdController,
              decoration: InputDecoration(
                labelText: 'Enter Student ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            SizedBox(height: 16),

            // Show Attendance Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (dateController.text.isNotEmpty &&
                      studentIdController.text.isNotEmpty &&
                      selectedSectionDropdown != null) {
                    viewStudentAttendance(studentIdController.text);
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Enter all fields')));
                  }
                },
                icon: Icon(
                  Icons.table_chart,
                  color: Colors.white, // White icon
                ),
                label: Text(
                  "Show Attendance Table",
                  style: TextStyle(color: Colors.white), // White text
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[500],
                  foregroundColor:
                      Colors.white, // Ensures default text/icon is white
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            Center(
              child: Text(
                "📊 Attendance Records",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(height: 10),

            attendanceRecords.isNotEmpty
                ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.indigo.shade100,
                        ),
                        border: TableBorder.all(color: Colors.grey),
                        columns: [
                          DataColumn(label: Text("Student ID")),
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("Section")),
                          DataColumn(label: Text("Status")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows:
                            attendanceRecords.map((record) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(record['studentId'].toString()),
                                  ),
                                  DataCell(Text(record['date'].toString())),
                                  DataCell(Text(record['section'].toString())),
                                  DataCell(Text(record['status'].toString())),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.orangeAccent,
                                      ),
                                      onPressed:
                                          () => populateUpdateFields(record),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                )
                : Center(child: Text("No attendance records found.")),

            SizedBox(height: 30),

            Text(
              "🔧 Update Attendance",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 12),

            // Update Attendance Form
            TextFormField(
              controller: updateStudentIdController,
              decoration: InputDecoration(
                labelText: 'Student ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 12),

            GestureDetector(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    updateDateController.text =
                        pickedDate.toIso8601String().split('T')[0];
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: updateDateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            TextFormField(
              controller: updateSectionController,
              decoration: InputDecoration(
                labelText: 'Section',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: updateStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              items:
                  statusOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  updateStatus = value!;
                });
              },
            ),

            SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (updateStudentIdController.text.isNotEmpty &&
                      updateDateController.text.isNotEmpty &&
                      updateSectionController.text.isNotEmpty &&
                      selectedAttendanceId != null) {
                    updateAttendance(selectedAttendanceId!, {
                      "studentId": updateStudentIdController.text,
                      "date": updateDateController.text,
                      "section": updateSectionController.text,
                      "status": updateStatus,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fill all update fields')),
                    );
                  }
                },
                icon: Icon(Icons.update),
                label: Text("Update Attendance"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor:
                      Colors.white, // Ensures default text/icon is white
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (selectedSection == 'Complaints') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Complaints",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SizedBox(height: 10),
          complaints.isNotEmpty
              ? Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.orange.shade100,
                      ),
                      columns: [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("Student ID")),
                        DataColumn(label: Text("Message")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows:
                          complaints.map((complaint) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(complaint['id']?.toString() ?? ''),
                                ),
                                DataCell(
                                  Text(
                                    complaint['studentId']?.toString() ?? '',
                                  ),
                                ),
                                DataCell(Text(complaint['message'] ?? '')),
                                DataCell(Text(complaint['status'] ?? '')),
                                DataCell(
                                  IconButton(
                                    icon: Icon(
                                      Icons.reply,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () {
                                      final TextEditingController
                                      responseController =
                                          TextEditingController();
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Respond to Complaint"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Complaint ID: ${complaint['id']}",
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  complaint['message'] ?? '',
                                                ),
                                                SizedBox(height: 10),
                                                TextField(
                                                  controller:
                                                      responseController,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "Enter your response",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  maxLines: 4,
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  respondToComplaint(
                                                    complaint['id'].toString(),
                                                    responseController.text,
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: Text(
                                                  "Send",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              )
              : Center(child: Text("No complaints found.")),
        ],
      );
    } else if (selectedSection == 'Events') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your dynamic form for submitting events
          buildDynamicForm(eventFormFields, 'Submit Event', () async {
            await submitEvent();
          }),

          SizedBox(height: 20),

          // Button to show event records
          ElevatedButton(
            onPressed: () async {
              await fetchEvents(); // Fetch events from backend
              setState(() {
                showEventsList = true; // Toggle visibility of events list
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Orange background
              foregroundColor: Colors.white, // White text color
            ),
            child: Text('Show Events Rec'),
          ),

          SizedBox(height: 20),

          // Conditionally show the events list
          if (showEventsList)
            events.isEmpty
                ? Text('No events found.')
                : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      child: ListTile(
                        title: Text(event['title'] ?? 'No Title'),
                        subtitle: Text(
                          event['description'] ?? 'No Description',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(event['date'] ?? ''),
                            SizedBox(width: 12),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Call your delete method here with event ID or index
                                deleteEvent(event['id']);
                              },
                              tooltip: 'Delete Event',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    }

    return Container();
  }

  void deleteEvent(String eventId) async {
    // TODO: Add backend call to delete event
    // For now, removing from local list:
    setState(() {
      events.removeWhere((event) => event['id'] == eventId);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Event deleted')));
  }

  Widget buildDynamicForm(
    List<Map<String, dynamic>> fields,
    String buttonText,
    Future<void> Function() onSubmit, {
    ButtonStyle? buttonStyle, // <-- Optional parameter
  }) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...fields.map(buildFormField).toList(),
          SizedBox(height: 20),
          Center(
            // Center the button
            child: ElevatedButton.icon(
              onPressed: () async {
                await onSubmit();
              },
              icon: Icon(Icons.send, color: Colors.white), // Optional icon
              label: Text(buttonText),
              style:
                  buttonStyle ??
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Dashboard'),
        backgroundColor: Colors.white,

        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[100]!, Colors.blue[300]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Staff',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildDrawerItem(Icons.assignment, 'Attendance', () {
              setState(() => selectedSection = 'Attendance');
              Navigator.pop(context);
            }),
            buildDrawerItem(Icons.warning, 'Complaints', () {
              setState(() => selectedSection = 'Complaints');
              Navigator.pop(context);
            }),
            buildDrawerItem(Icons.event, 'Events', () {
              setState(() => selectedSection = 'Events');
              Navigator.pop(context);
            }),
            Divider(color: Colors.grey.shade300),
            buildDrawerItem(Icons.logout, 'Logout', () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('jwt_token');
              Navigator.of(context).pushReplacementNamed('/login');
            }),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blue[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: buildSectionContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: TextStyle(color: Colors.black87, fontSize: 18)),
      hoverColor: Colors.lightBlueAccent.withOpacity(0.2),
      onTap: onTap,
    );
  }
}
