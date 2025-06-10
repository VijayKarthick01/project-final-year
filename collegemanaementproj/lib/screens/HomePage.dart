// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   bool isMobile(BuildContext context) =>
//       MediaQuery.of(context).size.width < 700;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       // Drawer for mobile
//       drawer:
//           isMobile(context)
//               ? Drawer(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     DrawerHeader(
//                       decoration: BoxDecoration(color: Color(0xFF00C3A5)),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.network(
//                             'https://cdn-icons-png.flaticon.com/512/3135/3135755.png',
//                             width: 48,
//                             height: 48,
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'CollegeManager',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 22,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.info_outline),
//                       title: Text('About Us'),
//                       onTap: () {
//                         Navigator.pop(context);
//                         showAboutDialog(
//                           context: context,
//                           applicationName: "CollegeManager",
//                           applicationVersion: "1.0",
//                           children: [
//                             Text("A modern college management platform."),
//                           ],
//                         );
//                       },
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.contact_mail),
//                       title: Text('Contact'),
//                       onTap: () {
//                         Navigator.pop(context);
//                         showDialog(
//                           context: context,
//                           builder:
//                               (context) => AlertDialog(
//                                 title: Text("Contact Us"),
//                                 content: Text(
//                                   "Email: support@collegemanager.com\nPhone: +91-1234567890",
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: Text("Close"),
//                                   ),
//                                 ],
//                               ),
//                         );
//                       },
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.help_outline),
//                       title: Text('Help'),
//                       onTap: () {
//                         Navigator.pop(context);
//                         showDialog(
//                           context: context,
//                           builder:
//                               (context) => AlertDialog(
//                                 title: Text("Help"),
//                                 content: Text(
//                                   "For assistance, visit our Help Center.",
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: Text("Close"),
//                                   ),
//                                 ],
//                               ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               )
//               : null,
//       backgroundColor: null,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 225, 175, 221),
//               Color.fromARGB(255, 114, 201, 211),
//               Color(0xFFFDF6F0),
//               Color.fromARGB(255, 230, 151, 208),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               // Top Bar
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 12,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Logo and branding
//                       Row(
//                         children: [
//                           Image.network(
//                             'https://cdn-icons-png.flaticon.com/512/3135/3135755.png',
//                             width: 40,
//                             height: 40,
//                           ),
//                           SizedBox(width: 10),
//                           RichText(
//                             text: TextSpan(
//                               style: theme.textTheme.titleLarge?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF222222),
//                                 fontSize: 26,
//                               ),
//                               children: [
//                                 TextSpan(text: 'College'),
//                                 TextSpan(
//                                   text: 'Manager',
//                                   style: TextStyle(color: Color(0xFF007E6A)),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       // Menu and buttons
//                       if (!isMobile(context))
//                         Row(
//                           children: [
//                             // Burger Menu Button
//                             PopupMenuButton<String>(
//                               icon: Icon(
//                                 Icons.menu,
//                                 color: Colors.black87,
//                                 size: 28,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               onSelected: (value) {
//                                 if (value == 'about') {
//                                   showAboutDialog(
//                                     context: context,
//                                     applicationName: "CollegeManager",
//                                     applicationVersion: "1.0",
//                                     children: [
//                                       Text(
//                                         "A modern college management platform.",
//                                       ),
//                                     ],
//                                   );
//                                 } else if (value == 'contact') {
//                                   showDialog(
//                                     context: context,
//                                     builder:
//                                         (context) => AlertDialog(
//                                           title: Text("Contact Us"),
//                                           content: Text(
//                                             "Email: support@collegemanager.com\nPhone: +91-1234567890",
//                                           ),
//                                           actions: [
//                                             TextButton(
//                                               onPressed:
//                                                   () => Navigator.pop(context),
//                                               child: Text("Close"),
//                                             ),
//                                           ],
//                                         ),
//                                   );
//                                 } else if (value == 'help') {
//                                   showDialog(
//                                     context: context,
//                                     builder:
//                                         (context) => AlertDialog(
//                                           title: Text("Help"),
//                                           content: Text(
//                                             "For assistance, visit our Help Center.",
//                                           ),
//                                           actions: [
//                                             TextButton(
//                                               onPressed:
//                                                   () => Navigator.pop(context),
//                                               child: Text("Close"),
//                                             ),
//                                           ],
//                                         ),
//                                   );
//                                 }
//                               },
//                               itemBuilder:
//                                   (context) => [
//                                     PopupMenuItem(
//                                       value: 'about',
//                                       child: ListTile(
//                                         leading: Icon(
//                                           Icons.info_outline,
//                                           color: Colors.blue,
//                                         ),
//                                         title: Text("About Us"),
//                                       ),
//                                     ),
//                                     PopupMenuItem(
//                                       value: 'contact',
//                                       child: ListTile(
//                                         leading: Icon(
//                                           Icons.contact_mail,
//                                           color: Colors.green,
//                                         ),
//                                         title: Text("Contact"),
//                                       ),
//                                     ),
//                                     PopupMenuItem(
//                                       value: 'help',
//                                       child: ListTile(
//                                         leading: Icon(
//                                           Icons.help_outline,
//                                           color: Colors.orange,
//                                         ),
//                                         title: Text("Help"),
//                                       ),
//                                     ),
//                                   ],
//                             ),
//                             SizedBox(width: 20),
//                             _HoverButton(
//                               text: 'Login',
//                               color: Color(0xFFFFC94A),
//                               textColor: Colors.black,
//                               onTap:
//                                   () => Navigator.pushNamed(context, '/login'),
//                             ),
//                             SizedBox(width: 16),
//                             _HoverButton(
//                               text: 'Sign Up',
//                               color: Color(0xFF00C3A5),
//                               textColor: Colors.white,
//                               onTap:
//                                   () =>
//                                       Navigator.pushNamed(context, '/register'),
//                             ),
//                           ],
//                         ),
//                       if (isMobile(context))
//                         Builder(
//                           builder:
//                               (context) => IconButton(
//                                 icon: Icon(
//                                   Icons.menu,
//                                   color: Colors.black87,
//                                   size: 28,
//                                 ),
//                                 onPressed:
//                                     () => Scaffold.of(context).openDrawer(),
//                               ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Main Content
//               Center(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
//                   child:
//                       isMobile(context)
//                           ? SingleChildScrollView(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 _MainTextBlock(theme: theme),
//                                 SizedBox(height: 28),
//                                 _ImageBlock(),
//                                 SizedBox(height: 32),
//                                 // Buttons at the bottom for mobile
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     _BottomButton(
//                                       text: 'Login',
//                                       color: Color(0xFFFFC94A),
//                                       textColor: Colors.black,
//                                       onTap:
//                                           () => Navigator.pushNamed(
//                                             context,
//                                             '/login',
//                                           ),
//                                     ),
//                                     SizedBox(width: 16),
//                                     _BottomButton(
//                                       text: 'Sign Up',
//                                       color: Color(0xFF00C3A5),
//                                       textColor: Colors.white,
//                                       onTap:
//                                           () => Navigator.pushNamed(
//                                             context,
//                                             '/register',
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           )
//                           : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: _MainTextBlock(theme: theme),
//                               ),
//                               SizedBox(width: 32),
//                               Expanded(flex: 2, child: _ImageBlock()),
//                             ],
//                           ),
//                 ),
//               ),
//               // Footer Name
//               Positioned(
//                 bottom: 20,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: Text(
//                     "Developed by VIJAY KARTHICK V",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                       fontSize: 16,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Main text block widget
// class _MainTextBlock extends StatelessWidget {
//   const _MainTextBlock({required this.theme});

//   final ThemeData theme;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 60),
//           Text(
//             "COLLEGE MANAGEMENT SYSTEM",
//             style: Theme.of(context).textTheme.labelLarge?.copyWith(
//               color: Colors.black87,
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               letterSpacing: 1.2,
//             ),
//           ),
//           SizedBox(height: 10),
//           Container(width: 40, height: 3, color: Color(0xFFFFC94A)),
//           SizedBox(height: 18),
//           Text(
//             "Simplify Administration, Empower Students & Staff",
//             style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF222222),
//               fontSize: 30,
//               height: 1.2,
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             "Our platform helps manage attendance, complaints, events, and more—seamlessly and securely. Welcome to your smart digital campus.",
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//               fontSize: 16,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 28),
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 22,
//                 // backgroundImage: NetworkImage(
//                 //   // 'https://randomuser.me/api/portraits/men/33.jpg',
//                 // ),
//               ),
//               SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Admin: Vijay Karthick V",
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF333333),
//                     ),
//                   ),
//                   Text(
//                     "May 24, 2025 · Version 1.0",
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodySmall?.copyWith(color: Colors.black54),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 32),

//           // ADVANTAGES SECTION (Scrollable if overflows)
//           Text(
//             "Key Advantages",
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               color: Color(0xFF1976D2),
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           SizedBox(height: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _AdvantageItem(
//                 icon: Icons.flash_on,
//                 text: "Instant access to student  data",
//                 color: Color(0xFF00C3A5),
//               ),
//               _AdvantageItem(
//                 icon: Icons.event_available,
//                 text: "Easy event & attendance management",
//                 color: Color(0xFFFFC94A),
//               ),
//               _AdvantageItem(
//                 icon: Icons.security,
//                 text: "Secure, role-based access for all users",
//                 color: Color(0xFF1976D2),
//               ),
//               _AdvantageItem(
//                 icon: Icons.support_agent,
//                 text: "24/7 support & cloud backup",
//                 color: Color(0xFFEA4C89),
//               ),
//               // Add more _AdvantageItem widgets if needed!
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Helper widget for a single advantage
// class _AdvantageItem extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Color color;

//   const _AdvantageItem({
//     required this.icon,
//     required this.text,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 22),
//           SizedBox(width: 10),
//           Flexible(
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Image block widget
// class _ImageBlock extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 700;
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black12, width: 4),
//           borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 16,
//               offset: Offset(4, 8),
//             ),
//           ],
//         ),
//         child: Image.network(
//           'https://picsum.photos/200',
//           width: 48,
//           height: 48,
//           errorBuilder: (context, error, stackTrace) {
//             return Icon(Icons.error, size: 48, color: Colors.red);
//           },
//         ),
//       ),
//     );
//   }
// }

// // Desktop hover button
// class _HoverButton extends StatefulWidget {
//   final String text;
//   final Color color;
//   final Color textColor;
//   final VoidCallback onTap;

//   const _HoverButton({
//     required this.text,
//     required this.color,
//     required this.textColor,
//     required this.onTap,
//   });

//   @override
//   State<_HoverButton> createState() => _HoverButtonState();
// }

// class _HoverButtonState extends State<_HoverButton> {
//   bool _hovering = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _hovering = true),
//       onExit: (_) => setState(() => _hovering = false),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         curve: Curves.easeInOut,
//         decoration: BoxDecoration(
//           color: _hovering ? widget.color.withOpacity(0.85) : widget.color,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow:
//               _hovering
//                   ? [
//                     BoxShadow(
//                       color: widget.color.withOpacity(0.3),
//                       blurRadius: 12,
//                       offset: Offset(0, 4),
//                     ),
//                   ]
//                   : [],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(30),
//             onTap: widget.onTap,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
//               child: Text(
//                 widget.text,
//                 style: TextStyle(
//                   color: widget.textColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 17,
//                   letterSpacing: 1.1,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Mobile bottom button (no hover)
// class _BottomButton extends StatelessWidget {
//   final String text;
//   final Color color;
//   final Color textColor;
//   final VoidCallback onTap;

//   const _BottomButton({
//     required this.text,
//     required this.color,
//     required this.textColor,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onTap,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: textColor,
//         padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
//         shape: StadiumBorder(),
//         elevation: 4,
//         textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       ),
//       child: Text(text),
//     );
//   }
// }
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Transparent app bar with menu buttons
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _TopBarButtonn(
            icon: Icons.info_outline,
            text: 'About',
            onTap:
                () => _showModalInfo(
                  context,
                  'About College Management System',
                  '''This is a full-featured College Management System built with role-based access (RBA):

🔹 Admin:
- Manage staff and students
- View and respond to complaints
- Post and manage events
- View system-wide statistics

🔹 Staff:
- Mark and update student attendance
- Post events and announcements
- Respond to student complaints

🔹 Student:
- View personal attendance records
- Submit complaints
- View upcoming events

Developed with ❤️ by  
Admin: Vijay Karthick V''',
                ),
          ),
          _TopBarButtonn(
            icon: Icons.contact_mail_outlined,
            text: 'Contact Us',
            onTap:
                () => _showModalInfo(
                  context,
                  'Contact Us',
                  '''📧 Email: vvijaykarthickvk@gmail.com  
📞 Phone: +91 96295 66671''',
                ),
          ),
          _TopBarButtonn(
            icon: Icons.help_outline,
            text: 'Help',
            onTap:
                () => _showModalInfo(
                  context,
                  'Help',
                  '''For assistance, contact:  
📧 vijaykarthickvk@gmail.com''',
                ),
          ),
          SizedBox(width: 16),
        ],
      ),
      extendBodyBehindAppBar:
          true, // so content is behind the transparent appbar
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // subtle gradient background
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0x2F2C27)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Container(
              // Semi-transparent container so bg shows through
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3), // 30% black opacity
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo or title
                  Text(
                    'College Management System',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width > 600 ? 48 : 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Manage Attendance, Events, Complaints and More',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: size.width > 600 ? 20 : 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),

                  // Feature icons row (optional)
                  if (size.width > 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _FeatureIcon(
                          icon: Icons.event_available,
                          label: 'Events',
                        ),
                        SizedBox(width: 48),
                        _FeatureIcon(
                          icon: Icons.assignment_turned_in,
                          label: 'Attendance',
                        ),
                        SizedBox(width: 48),
                        _FeatureIcon(icon: Icons.feedback, label: 'Complaints'),
                        SizedBox(width: 48),
                        _FeatureIcon(icon: Icons.people, label: 'Users'),
                      ],
                    ),
                  if (size.width > 600) SizedBox(height: 40),

                  // Buttons row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _HoverButton(
                        text: 'Login',
                        color: Color(0xFFFFC94A),
                        textColor: Colors.black,
                        onTap: () => Navigator.pushNamed(context, '/login'),
                      ),
                      SizedBox(width: 24),
                      _HoverButton(
                        text: 'Sign Up',
                        color: Color(0xFF00C3A5),
                        textColor: Colors.white,
                        onTap: () => Navigator.pushNamed(context, '/register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showModalInfo(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.85,
          minChildSize: 0.3,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.grey[300],
                      height: 1.5,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: Text(
              content,
              style: TextStyle(color: Colors.grey[300], height: 1.5),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }
}

class _TopBarButtonn extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarButtonn({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white24,
          child: Icon(icon, size: 36, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
      ],
    );
  }
}

class _HoverButton extends StatefulWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _HoverButton({
    Key? key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  __HoverButtonState createState() => __HoverButtonState();
}

class __HoverButtonState extends State<_HoverButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = _hovering ? widget.color.withOpacity(0.85) : widget.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow:
                _hovering
                    ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.5),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _TopBarButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white70,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      child: Text(text),
    );
  }
}
