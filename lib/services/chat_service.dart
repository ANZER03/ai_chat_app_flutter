import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String role;
  final String content;
  final List<Map<String, dynamic>>? images;

  ChatMessage({required this.role, required this.content, this.images});

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> parts = [];

    // Add text content if not empty
    if (content.isNotEmpty) {
      parts.add({'text': content});
    }

    // Add images if provided
    if (images != null && images!.isNotEmpty) {
      parts.addAll(images!);
    }

    return {'role': role, 'parts': parts};
  }
}

class ChatService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String _defaultModel = 'gemini-2.5-flash';

  final String _apiKey;
  final String _model;

  ChatService({required String apiKey, String? model})
    : _apiKey = apiKey,
      _model = model ?? _defaultModel {}

  /// Sends a message to the Gemini API and returns the response
  Future<String> sendMessage(List<ChatMessage> messages) async {
    if (_apiKey.isEmpty) {
      throw Exception('API key is not configured');
    }

    final url = '$_baseUrl/models/$_model:generateContent';

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'contents': messages.map((message) => message.toJson()).toList(),
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'x-goog-api-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Check the response status
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract the generated content
        final generatedText =
            data['candidates']?[0]['content']['parts'][0]['text'] ??
            'No response from AI';
        return generatedText;
      } else {
        throw Exception(
          'Failed to generate content: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Error communicating with Gemini API: $e');
    }
  }

  /// Simple method to get a response to a single message
  Future<String> getSimpleResponse(String message) async {
    final messages = [ChatMessage(role: 'user', content: message)];
    return sendMessage(messages);
  }

  /// Method to continue a conversation with history
  Future<String> continueConversation(
    List<ChatMessage> conversationHistory,
    String newMessage, {
    List<Map<String, dynamic>>? images,
  }) async {
    final messages = [...conversationHistory];
    messages.add(
      ChatMessage(role: 'user', content: newMessage, images: images),
    );
    return sendMessage(messages);
  }

  /// Method to send a message with images
  Future<String> sendMessageWithImages(
    String message,
    List<Map<String, dynamic>> images,
  ) async {
    final messages = [
      ChatMessage(role: 'user', content: message, images: images),
    ];
    return sendMessage(messages);
  }
}

void main() async {
  // Create a chat service instance with API key
  final chatService = ChatService(apiKey: '');

  try {
    // Test with a conversation
    print('Starting conversation with Gemini...');

    // Initial message
    final initialMessage = ChatMessage(
      role: 'user',
      content: 'Hello, can you introduce yourself?',
    );
    final firstResponse = await chatService.sendMessage([initialMessage]);
    print('First response from Gemini:');
    print(firstResponse);

    // Continue the conversation
    final conversationHistory = [
      initialMessage,
      ChatMessage(role: 'model', content: firstResponse),
    ];

    final followUpResponse = await chatService.continueConversation(
      conversationHistory,
      'What can you help me with?',
    );

    print('Follow-up response from Gemini:');
    print(followUpResponse);
  } catch (e) {
    print('Error testing chat service: $e');
  }
}
