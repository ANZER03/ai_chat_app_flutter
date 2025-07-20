import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool isPressedThink = false;
  bool isPressedDeepSearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6F5),
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            // Handle drawer open
          },
        ),
        title: GestureDetector(
          onTap: () {
            // Handle title click
            print("Anzer!!");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Anzer',
                style: GoogleFonts.ubuntu(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.maps_ugc_outlined),
            onPressed: () {
              // Handle new page creation
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Text Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.transparent,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome to Chat Page\nYour messages will appear here',
                    style: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Fixed Bottom Container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFC),
              border: Border.all(color: const Color(0xFFE4E4E2), width: 1.2),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            margin: const EdgeInsets.fromLTRB(10, 1, 10, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    maxLines: null,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Ask Anzer',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFEFEFED),
                          ),
                          icon: const Icon(Icons.attach_file, size: 24),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                              color: isPressedDeepSearch
                                  ? Colors.transparent
                                  : const Color(0xFFE4E4E2),
                              width: 0,
                            ),
                            backgroundColor: isPressedDeepSearch
                                ? const Color(0xFF141313)
                                : const Color(0xFFEFEFED),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          icon: Icon(
                            Icons.public,
                            color: isPressedDeepSearch
                                ? Colors.white
                                : const Color(0xFF141313),
                            size: 20,
                          ),
                          label: Text(
                            'DeepSearch',
                            style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isPressedDeepSearch
                                  ? Colors.white
                                  : const Color(0xFF141313),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isPressedDeepSearch = !isPressedDeepSearch;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                              color: isPressedThink
                                  ? Colors.transparent
                                  : const Color(0xFFE4E4E2),
                              width: 0,
                            ),
                            backgroundColor: isPressedThink
                                ? const Color(0xFF141313)
                                : const Color(0xFFEFEFED),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          icon: Icon(
                            Icons.lightbulb_outlined,
                            color: isPressedThink
                                ? Colors.white
                                : const Color(0xFF141313),
                            size: 20,
                          ),
                          label: Text(
                            'Think',
                            style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isPressedThink
                                  ? Colors.white
                                  : const Color(0xFF141313),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isPressedThink = !isPressedThink;
                            });
                          },
                        ),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
