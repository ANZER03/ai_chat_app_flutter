import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF8F6F5),
      width: 400.0,
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
                    onPressed: ()=>{
                      
                    },
                    icon:  Icon(
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
                  width: 150,

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
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(onPressed: () => {}, icon: Icon(Icons.settings)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
