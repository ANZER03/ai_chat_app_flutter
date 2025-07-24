import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map> conversations = [
    {'title': 'Chat with John', 'time': '5:02 PM'},
    {'title': 'Team Meeting Notes', 'time': '4:45 PM'},
    {'title': 'Project Discussion', 'time': '3:30 PM'},
    {'title': 'Personal Notes', 'time': '2:15 PM'},
    {'title': 'Chat with John', 'time': '1:20 PM'},
    {'title': 'Team Meeting Notes', 'time': '12:45 PM'},
    {'title': 'Project Discussion', 'time': '11:30 AM'},
    {'title': 'Personal Notes', 'time': '10:15 AM'},
    {'title': 'Chat with John', 'time': '9:45 AM'},
    {'title': 'Team Meeting Notes', 'time': '9:20 AM'},
    {'title': 'Project Discussion', 'time': '8:30 AM'},
    {'title': 'Personal Notes', 'time': '8:00 AM'},
  ];
  List<Map> filteredConversations = [];

  @override
  void initState() {
    super.initState();
    filteredConversations = conversations;
    _searchController.addListener(_filterConversations);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterConversations() {
    setState(() {
      filteredConversations = conversations
          .where(
            (conversation) => conversation['title'].toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F6F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF141313),
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.ubuntu(
              fontSize: 16,
              color: const Color(0xFF7d7c73),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7d7c73),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141313),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      // Clear stored credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('username');

      // Navigate to login page
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _showMessageOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF8F6F5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top divider/handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 90, 90, 90),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.push_pin_outlined,
                  color: Color.fromARGB(255, 29, 29, 29),
                  weight: 26,
                  size: 24,
                ),
                title: Text(
                  'Pin',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle pin action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Pinned: ${filteredConversations[index]['title']}',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: Color.fromARGB(255, 29, 29, 29),
                  weight: 26,
                  size: 24,
                ),
                title: Text(
                  'Rename',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle rename action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Rename: ${filteredConversations[index]['title']}',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  weight: 26,
                  color: Colors.red,
                  size: 24,
                ),
                title: Text(
                  'Delete',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle delete action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleted: ${filteredConversations[index]['title']}',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF8F6F5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header with Search
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE4E4E2), width: 0.5),
                ),
              ),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        cursorColor: const Color.fromARGB(255, 60, 61, 61),
                        controller: _searchController,
                        // style: GoogleFonts.ubuntu(
                        //   fontSize: 14,
                        //   color: const Color.fromARGB(255, 53, 53, 53),
                        //   fontWeight: FontWeight.w400,
                        // ),
                        decoration: InputDecoration(
                          labelText: 'Search conversations...',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: 'Search conversations...',
                          // hintStyle: GoogleFonts.ubuntu(
                          //   fontSize: 14,
                          //   color: const Color.fromARGB(255, 53, 53, 53),
                          //   fontWeight: FontWeight.w400,
                          // ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 133, 133, 133),
                            size: 28,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFE4E4E2),
                              width: 0.8,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFE4E4E2),
                              width: 0.8,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFE4E4E2),
                              width: 0.8,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Scaffold.of(context).closeDrawer();
                    },
                    icon: const Icon(
                      Icons.keyboard_double_arrow_right,
                      size: 28,
                      color: Color.fromARGB(255, 133, 133, 133),
                    ),
                  ),
                ],
              ),
            ),
            // Conversation List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                itemCount: filteredConversations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    trailing: IconButton(
                      onPressed: () => _showMessageOptions(context, index),
                      icon: Icon(
                        Icons.more_vert,
                        size: 20,
                        color: Color.fromARGB(204, 196, 196, 196),
                      ),
                    ),
                    title: Text(
                      filteredConversations[index]['title'],
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color.fromARGB(221, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ), // Adjust this value to increase/decrease space
                      child: Text(
                        filteredConversations[index]['time'],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Handle conversation selection
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Selected: ${filteredConversations[index]}',
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    // leading: const Icon(
                    //   Icons.chat_bubble_outline,
                    //   color: Color(0xFF007AFF),
                    // ),
                  );
                },
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE4E4E2), width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpeg',
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Anouar Zerrik',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _handleLogout,
                    icon: Icon(Icons.logout, color: const Color(0xFF7d7c73)),
                    tooltip: 'Logout',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
