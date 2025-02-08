import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class ScriptGeneratorService {
  // Initialize the GenerativeModel with the API key
  final GenerativeModel _model = GenerativeModel(
    model: "gemini-pro",
    apiKey: "AIzaSyChd40HjxUtB0FXNqXh-FuGp2duXDpcGrQ",
  );

  /// Fetches a script based on user input
  Future<String?> generateScript(String userInput) async {
    if (userInput.isEmpty) return "Please enter a valid prompt!";

    try {
      final content = [Content.text(userInput)];
      final response = await _model.generateContent(content);

      return response.text; // Return generated script
    } catch (error) {
      debugPrint("Error generating script: $error");
      return "Failed to generate script. Please try again.";
    }
  }
}
