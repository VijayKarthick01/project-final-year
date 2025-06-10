import 'package:collegemanaementproj/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final String baseUrl = 'http://192.168.201.189:8080/api/admin';
  List<dynamic> users = [];
  Map<String, dynamic> stats = {};
  bool isLoading = true;
  bool isAuthorized = false;

  @override
  void initState() {
    super.initState();
    checkAuthorization();
  }

  Future<void> checkAuthorization() async {
    try {
      String? token = await getToken();
      if (token == null) throw Exception("Token not found");

      final response = await http.get(
        Uri.parse('$baseUrl/check-role'),
        headers: getHeaders(token),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        String extractedRole = json.decode(response.body)['role'] ?? "";
        setState(() {
          isAuthorized = extractedRole == "ROLE_ADMIN";
          if (isAuthorized) fetchDashboardData();
        });
      } else {
        setState(() => isAuthorized = false);
      }
    } catch (e) {
      showSnackBar("Authorization error: $e");
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      String? token = await getToken();
      if (token == null) throw Exception("Token not found");

      final responses = await Future.wait([
        http.get(Uri.parse('$baseUrl/users'), headers: getHeaders(token)),
        http.get(Uri.parse('$baseUrl/dashboard'), headers: getHeaders(token)),
      ]);

      if (!mounted) return;

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        setState(() {
          users = json.decode(responses[0].body) ?? [];
          stats = json.decode(responses[1].body) ?? {};
          isLoading = false;
          print(users);
          print(stats);
        });
      } else {
        showSnackBar("Failed to load data");
      }
    } catch (e) {
      showSnackBar("Error fetching data: ${e.toString()}");
    }
  }

  Future<void> updateUserStatus(String userId, bool isActive) async {
    bool confirmAction = await showStatusConfirmationDialog(isActive);
    if (!confirmAction) return;

    try {
      String? token = await getToken();
      if (token == null) throw Exception("Token not found");

      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId/status?isActive=$isActive'),
        headers: getHeaders(token),
      );

      if (!mounted) return;

      showSnackBar(
        response.statusCode == 200
            ? (isActive ? "User activated!" : "User blocked!")
            : "Failed to update status",
      );
      fetchDashboardData();
    } catch (e) {
      showSnackBar("Error updating status: ${e.toString()}");
    }
  }

  // Confirmation Dialog for Lock/Unlock
  Future<bool> showStatusConfirmationDialog(bool isActive) async {
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Row(
                  children: [
                    Icon(
                      isActive ? Icons.lock_open : Icons.lock,
                      color: isActive ? Colors.green : Colors.red,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      isActive ? "Unlock User" : "Block User",
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  isActive
                      ? "Are you sure you want to unlock this user?"
                      : "Are you sure you want to block this user?",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive ? Colors.green : Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isActive ? "Unlock" : "Block",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<void> deleteUser(String userId) async {
    bool confirmDelete = await showDeleteConfirmationDialog();
    if (!confirmDelete) return;

    try {
      String? token = await getToken();
      if (token == null) throw Exception("Token not found");

      final response = await http.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: getHeaders(token),
      );

      if (!mounted) return;

      showSnackBar(
        response.statusCode == 200 ? "User deleted!" : "Failed to delete user",
      );
      fetchDashboardData();
    } catch (e) {
      showSnackBar("Error deleting user: ${e.toString()}");
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Map<String, String> getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  void showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<bool> showDeleteConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Confirm Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  "Are you sure you want to delete this user? This action cannot be undone.",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthorized) {
      return Scaffold(
        appBar: AppBar(title: Text("Unauthorized")),
        body: Center(child: Text("You are not authorized to access this page")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Admin Dashboard",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blueGrey.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('jwt_token');
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                dashboardCard(
                                  "Total Users",
                                  stats['totalUsers'] ?? 0,
                                  Icons.people,
                                  Colors.blue,
                                ),
                                dashboardCard(
                                  "Active Users",
                                  stats['activeUsers'] ?? 0,
                                  Icons.check_circle,
                                  Colors.green,
                                ),
                                dashboardCard(
                                  "Blocked Users",
                                  stats['inactiveUsers'] ?? 0,
                                  Icons.block,
                                  Colors.red,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              dashboardCard(
                                "Total Users",
                                stats['totalUsers'] ?? 0,
                                Icons.people,
                                Colors.blue,
                              ),
                              dashboardCard(
                                "Active Users",
                                stats['activeUsers'] ?? 0,
                                Icons.check_circle,
                                Colors.green,
                              ),
                              dashboardCard(
                                "Blocked Users",
                                stats['inactiveUsers'] ?? 0,
                                Icons.block,
                                Colors.red,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),

                  Expanded(
                    child:
                        users.isEmpty
                            ? Center(child: Text("No users found"))
                            : ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return Card(
                                  color: Colors.blueGrey.shade100,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: Tooltip(
                                    message:
                                        "Role: ${user['role'] ?? 'Unknown'}", // Show role when hovered
                                    child: ListTile(
                                      title: Text(
                                        user['name'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        user['email'] ?? 'No Email',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              user['active'] == true
                                                  ? Icons.lock_open
                                                  : Icons.lock,
                                              color:
                                                  user['active'] == true
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                            onPressed:
                                                () => updateUserStatus(
                                                  user['id'],
                                                  !(user['active'] ?? false),
                                                ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed:
                                                () => deleteUser(user['id']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }

  Widget dashboardCard(String title, int count, IconData icon, Color color) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blueGrey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
