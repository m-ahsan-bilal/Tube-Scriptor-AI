import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ScriptGeneratorService {
  // Initialize the GenerativeModel with the API key
  final GenerativeModel _model = GenerativeModel(
    model: "gemini-pro",
    apiKey: "AIzaSyChd40HjxUtB0FXNqXh-FuGp2duXDpcGrQ",
  );

  // Fetches a script based on user input
  Future<String?> generateScript(String userInput) async {
    if (userInput.isEmpty) return "Please enter a valid prompt!";
// try catch
    try {
      final content = [Content.text(userInput)];
      final response = await _model.generateContent(content);

// return scriot
      return response.text;
    } catch (error) {
      debugPrint("Error generating script: $error");
      return "Failed to generate script. Please try again.";
    }
  }
}

// deep seek api service

// class ScriptGeneratorService {
//   // Your DeepSeek API key
//   final String _apiKey = "sk-2001b8e99b5d4f4cac9d51572c47ae45";

//   // DeepSeek API endpoint
//   final String _apiUrl =
//       "https://api.deepseek.com"; // Replace with the actual endpoint

//   // Fetches a script based on user input
//   Future<String?> generateScript(String userInput) async {
//     if (userInput.isEmpty) return "Please enter a valid prompt!";

//     try {
//       // Prepare the request payload
//       final Map<String, dynamic> payload = {
//         "model": "deepseek-chat",
//         "messages": [
//           {
//             "role": "user",
//             "content": userInput,
//           }
//         ],
//         "max_tokens": 150, // Adjust as needed
//       };

//       // Make the POST request to the DeepSeek API
//       final response = await http.post(
//         Uri.parse(_apiUrl),
//         headers: {
//           "Authorization": "Bearer $_apiKey",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(payload),
//       );

//       // Check if the request was successful
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         // Extract the generated content from the response
//         return responseData["choices"][0]["message"]["content"];
//       } else {
//         debugPrint("Error: ${response.statusCode}, ${response.body}");
//         return "Failed to generate script. Please try again.";
//       }
//     } catch (error) {
//       debugPrint("Error generating script: $error");
//       return "Failed to generate script. Please try again.";
//     }
//   }
// }
