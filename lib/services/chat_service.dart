import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String role;
  final String content;
  final List<Map<String, dynamic>>? images;

  ChatMessage({required this.role, required this.content, this.images});

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> parts = [];

    if (content.isNotEmpty) {
      parts.add({'text': content});
    }

    if (images != null && images!.isNotEmpty) {
      parts.addAll(images!);
    }

    return {'role': role, 'parts': parts};
  }
}

class ChatService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String _defaultModel = 'gemini-2.5-flash';

  final String _apiKey;
  final String _model;

  ChatService({required String apiKey, String? model})
      : _apiKey = apiKey,
        _model = model ?? _defaultModel;

  /// Streams messages from the Gemini API and updates the last AI message
  Stream<String> streamMessage(List<ChatMessage> messages) async* {
    if (_apiKey.isEmpty) {
      throw Exception('API key is not configured');
    }

    final url = '$_baseUrl/models/$_model:streamGenerateContent?alt=sse';

    final requestBody = {
      'contents': messages.map((message) => message.toJson()).toList(),
    };

    try {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse(url))
        ..headers['x-goog-api-key'] = _apiKey
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode(requestBody);

      final response = await client.send(request);

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to stream content: ${response.statusCode} ${response.reasonPhrase}');
      }

      String accumulatedResponse = '';

      await for (final chunk in response.stream.transform(utf8.decoder)) {
        // Process SSE events
        final lines = chunk.split('\n');
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6); // Remove 'data: ' prefix
            if (data.isNotEmpty) {
              try {
                final jsonData = jsonDecode(data);
                final text = jsonData['candidates']?[0]['content']['parts'][0]['text'] ?? '';
                if (text.isNotEmpty) {
                  accumulatedResponse += text;
                  yield accumulatedResponse; // Yield the accumulated response
                }
              } catch (e) {
                // Skip malformed JSON lines
                continue;
              }
            }
          }
        }
      }

      client.close();
    } catch (e) {
      throw Exception('Error streaming from Gemini API: $e');
    }
  }

  /// Streams a response to a single message
  Stream<String> getSimpleStreamResponse(String message) {
    final messages = [ChatMessage(role: 'user', content: message)];
    return streamMessage(messages);
  }

  /// Streams a response continuing a conversation with history
  Stream<String> continueConversationStream(
    List<ChatMessage> conversationHistory,
    String newMessage, {
    List<Map<String, dynamic>>? images,
  }) {
    final messages = [...conversationHistory];
    messages.add(ChatMessage(role: 'user', content: newMessage, images: images));
    return streamMessage(messages);
  }

  /// Streams a response for a message with images
  Stream<String> sendMessageWithImagesStream(
    String message,
    List<Map<String, dynamic>> images,
  ) {
    final messages = [ChatMessage(role: 'user', content: message, images: images)];
    return streamMessage(messages);
  }
}

void main() async {
  final chatService = ChatService(apiKey: '');

  try {
    print('Starting streaming conversation with Gemini...');

    // Initial streaming message
    final message = 'Explain how AI works';
    print('Sending message: $message');
    
    final stream = chatService.getSimpleStreamResponse(message);
    String lastMessage = '';

    await for (final response in stream) {
      // Clear previous line and update with new response
      print('\r${' ' * lastMessage.length}\r$response');
      lastMessage = response;
    }

    print('\nStreaming completed.');
  } catch (e) {
    print('Error testing streaming chat service: $e');
  }
}