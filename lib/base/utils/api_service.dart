import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _apiUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static final String? _apiKey = dotenv.env['API_KEY'];

  static Future<String?> sendMessageToAPI(
      String userMessage, String agentName) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey'
    };

    final body = jsonEncode({
      'model': 'llama3-8b-8192',
      'messages': [
        {'role': 'user', 'content': userMessage}
      ]
    });

    try {
      final response =
          await http.post(Uri.parse(_apiUrl), headers: headers, body: body);
      await http.post(Uri.parse(_apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['choices'][0]['message']['content'];
      } else {
        print("Failed to get response: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }
}
