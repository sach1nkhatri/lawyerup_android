import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatFakeBloc extends ChangeNotifier {
  final List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  Future<void> sendMessage(String userText) async {
    _messages.add({'text': userText, 'isUser': true});
    notifyListeners();

    try {
      const url = 'http://10.0.2.2:1234/v1/chat/completions';

      final request = http.Request('POST', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          "messages": [
            {"role": "user", "content": userText}
          ],
          "max_tokens": 2000,
          "temperature": 0.7,
          "stream": true
        });

      final response = await request.send();

      StringBuffer buffer = StringBuffer();
      _messages.add({'text': '', 'isUser': false}); // Placeholder for assistant
      notifyListeners();

      await for (var chunk in response.stream.transform(utf8.decoder)) {
        for (var line in chunk.split('\n')) {
          if (line.startsWith('data: ')) {
            final jsonLine = line.replaceFirst('data: ', '').trim();
            if (jsonLine == '[DONE]') break;
            final data = jsonDecode(jsonLine);
            final delta = data['choices'][0]['delta'];
            final newText = delta['content'];
            if (newText != null) {
              buffer.write(newText);
              _messages[_messages.length - 1]['text'] = buffer.toString();
              notifyListeners();
            }
          }
        }
      }
    } catch (e) {
      _messages.add({'text': 'Error: $e', 'isUser': false});
      notifyListeners();
    }
  }
}
