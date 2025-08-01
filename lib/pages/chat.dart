import 'package:ai_chat_app/services/chat_service.dart';
import 'package:ai_chat_app/widgets/ai_message.dart';
import 'package:ai_chat_app/widgets/drawer.dart';
import 'package:ai_chat_app/widgets/user_message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;

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
  final List<Map<String, dynamic>> _messages = [];
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

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
        _scrollController
            .position
            .maxScrollExtent, // Scroll to the top of the list
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = _textController.text.trim();
    final List<Map<String, dynamic>> imageData = await _mapImagesToJson();

    setState(() {
      // Add user message to the list with images
      _messages.add({
        "role": "user",
        "message": userMessage,
        "images": List<File>.from(_selectedImages),
      });

      // Clear the text field
      _textController.clear();
      _selectedImages.clear();
    });

    // Scroll to bottom after adding message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Get AI response
    await _AIResponse(userMessage, imageData);
  }

  Future<void> _AIResponse(
    String userMessage,
    List<Map<String, dynamic>> images,
  ) async {
    final List<ChatMessage> messages = _messages
        .map(
          (value) => ChatMessage(
            role: value['role'] ?? '',
            content: value['message'] ?? '',
          ),
        )
        .toList();

    final Response = await chatService.continueConversation(
      messages,
      userMessage,
      images: images.isNotEmpty ? images : null,
    );

    setState(() {
      _messages.add({"role": "model", "message": Response});
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

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        _selectedImages.add(imageFile);
      });
    }
  }

  Future<List<Map<String, dynamic>>> _mapImagesToJson() async {
    List<Map<String, dynamic>> jsonList = [];
    for (File imageFile in _selectedImages) {
      // Convert image to Base64
      final bytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(bytes);

      // Determine MIME type based on file extension
      String mimeType = 'image/jpeg'; // Default to JPEG
      String extension = path.extension(imageFile.path).toLowerCase();
      if (extension == '.png') {
        mimeType = 'image/png';
      } else if (extension == '.jpg' || extension == '.jpeg') {
        mimeType = 'image/jpeg';
      }

      // Create JSON structure for the image
      final Map<String, dynamic> imageJson = {
        'inlineData': {'mimeType': mimeType, 'data': base64Image},
      };
      jsonList.add(imageJson);
    }

    return jsonList;
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _startNewConversation() {
    setState(() {
      _messages.clear();
      _selectedImages.clear();
      _textController.clear();
      isPressedThink = false;
      isPressedDeepSearch = false;
      isAIResponding = false;
    });

    // Unfocus any active text field
    FocusScope.of(context).unfocus();

    // // Optional: Show a brief confirmation
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('New conversation started'),
    //     duration: Duration(seconds: 1),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEdgeDragWidth: 100,
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
            onPressed: _startNewConversation,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Unfocus text field when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Opacity(
                        opacity: 0.2, // Control opacity here (0.0 to 1.0)
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey.withOpacity(
                              0.5,
                            ), // Control color and additional opacity
                            BlendMode.modulate,
                          ),
                          child: Image.asset(
                            'assets/images/logo-anzer.png',
                            width: 230, // Control size
                            height: 230,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          if (message['role'] == 'user') {
                            return UserMessage(
                              message: message['message']!,
                              images: message['images'] as List<File>?,
                            );
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
                color: const Color.fromARGB(255, 255, 255, 255),
                border: Border.all(color: const Color(0xFFE4E4E2), width: 1.2),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              margin: const EdgeInsets.fromLTRB(4, 1, 4, 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image preview list
                  if (_selectedImages.isNotEmpty)
                    Container(
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.file(
                                    _selectedImages[index],
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          224,
                                          224,
                                          224,
                                        ).withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      reverse: true, // ensures keyboard doesn’t cover content
                      child: GestureDetector(
                        onTap: () {
                          // Request focus when text field is tapped
                          _focusNode.requestFocus();
                        },
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
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
                                  onTap: () => {_pickImage(ImageSource.camera)},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 23.0,
                                    ),
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
                                  onTap: () => {
                                    _pickImage(ImageSource.gallery),
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 23.0,
                                    ),
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
                              FocusScope.of(context).unfocus();
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
                              FocusScope.of(context).unfocus();
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
      ),
    );
  }
}
