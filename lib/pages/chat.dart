import 'package:ai_chat_app/services/chat_service.dart';
import 'package:ai_chat_app/widgets/ai_message.dart';
import 'package:ai_chat_app/widgets/drawer.dart';
import 'package:ai_chat_app/widgets/user_message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

PopupMenuItem<String> _buildPopupMenuItem({
  required String value,
  required String title,
  required String description,
  required String slectedModel,
}) {
  return PopupMenuItem<String>(
    value: value,
    child: Container(
      // Set a fixed width for the menu item
      width:
          500, // You can adjust this value to make the menu wider or narrower
      // Add vertical padding to create space between items
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 1.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
            Visibility(
              visible: slectedModel == value ? true : false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Icon(Icons.task_alt, color: Colors.black, size: 19),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ChatState extends State<Chat> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late String _apiKey;
  late ChatService chatService;
  final List<Map<String, String>> _messages = [];

  bool isPressedThink = false;
  bool isPressedDeepSearch = false;
  bool isAIResponding = false;
  String slectedModel = "gemini";

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    chatService = ChatService(apiKey: _apiKey);

    // Add post-frame callback to scroll to bottom on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0, // With reverse: true, 0 is the bottom of the list
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = _textController.text.trim();

    setState(() {
      // Add user message to the list
      _messages.add({"role": "user", "message": userMessage});

      // Clear the text field
      _textController.clear();
    });

    // Scroll to bottom after adding message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Get AI response
    await _AIResponse(userMessage);
  }

  Future<void> _AIResponse(String userMessage) async {
    final initialMessage = ChatMessage(role: 'user', content: userMessage);
    final firstResponse = await chatService.sendMessage([initialMessage]);
    setState(() {
      _messages.add({"role": "ai", "message": firstResponse});
    });
    // No scrolling after AI response
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      backgroundColor: const Color(0xFFF8F6F5),
      drawer: DrawerWidget(),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: const Color(0xFFF8F6F5),
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            FocusScope.of(context).unfocus(); // Ensure keyboard hides
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: PopupMenuButton<String>(
          offset: const Offset(0, 45),
          onSelected: (String value) {
            setState(() {
              slectedModel = value;
            });
            print('Selected model: $value');
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            _buildPopupMenuItem(
              value: 'gemini',
              title: 'Gemini 2.5',
              description: 'Smart',
              slectedModel: slectedModel,
            ),
            _buildPopupMenuItem(
              value: 'llama',
              title: 'Llama 4',
              description: 'Fast',
              slectedModel: slectedModel,
            ),
            _buildPopupMenuItem(
              value: 'gpt-4',
              title: 'GPT 4.1',
              description: 'Coding',
              slectedModel: slectedModel,
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: const Color(0xFFFCFCFC),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Anzer',
                style: GoogleFonts.ubuntu(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color.fromARGB(255, 99, 95, 95),
              ),
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
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  if (message['role'] == 'user') {
                    return UserMessage(message: message['message']!);
                  } else {
                    return AiMessage(message: message['message']!);
                  }
                },
              ),
            ),
          ),
          // Fixed Bottom Container
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color(0xFFE4E4E2), width: 1.2),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
                  child: SingleChildScrollView(
                    reverse: true, // ensures keyboard doesn’t cover content
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      // readOnly is always false by default (line removed)
                      // onTap logic is unnecessary (line removed)
                      autofocus: false,
                      onChanged: (text) {
                        setState(() {});
                      },
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                      textInputAction: TextInputAction.send,
                      cursorColor: const Color.fromARGB(255, 46, 46, 46),
                      maxLines: 6,
                      minLines: 1,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: 'Ask Anzer',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEFEFED),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: PopupMenuButton<String>(
                            tooltip: 'Attach',
                            icon: const Icon(
                              Icons.attach_file,
                              size: 24,
                              color: Color(0xFF141313),
                            ),
                            color: Colors.white,
                            offset: const Offset(
                              0,
                              -230,
                            ), // Larger negative y for more margin below menu
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                30.0,
                              ), // Strongly rounded menu corners
                            ),
                            onSelected: (String value) {
                              print('Selected: $value');
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'camera',
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 23.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE4E4E2),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 18,
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.black87,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 13),
                                      Text(
                                        'Camera',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'photos',
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 23.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE4E4E2),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          radius: 18,
                                          child: Icon(
                                            Icons.photo_outlined,
                                            color: Colors.black87,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 13),
                                      Text(
                                        'Photos',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'files',
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Color(0xFFE4E4E2),
                                          width: 1.2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                        radius: 18,
                                        child: Icon(
                                          Icons.insert_drive_file_outlined,
                                          color: Colors.black87,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 13),
                                    Text(
                                      'Files',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                              horizontal: 13,
                              vertical: 10,
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
                              horizontal: 13,
                              vertical: 10,
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
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        fixedSize: _textController.text.isEmpty
                            ? const Size(35, 35)
                            : const Size(40, 40),
                      ),
                      icon: Icon(
                        _textController.text.isEmpty
                            ? Icons.graphic_eq
                            : Icons.send,
                        size: _textController.text.isEmpty ? 22 : 25,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: _textController.text.isEmpty
                          ? () {
                              // Handle voice input or other action when text is empty
                              print('Voice input pressed');
                            }
                          : _sendMessage,
                    ),
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
