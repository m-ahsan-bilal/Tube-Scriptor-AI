import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScriptGeneratorService {
  // Get the API key from environment variables
  final String? _apiKey = dotenv.env['GEMINI_API_KEY'];

  GenerativeModel? _model; // Make the model potentially null

  ScriptGeneratorService() {
    // Initialize the model only if the API key was found
    if (_apiKey != null && _apiKey.isNotEmpty) {
      _model = GenerativeModel(
        // *** Use the updated model name ***
        model: "gemini-2.0-flash", // <-- CHANGE THIS LINE
        apiKey: _apiKey,
        // Optional: You can add safety settings and generation config here if needed
        // safetySettings: [ SafetySetting(...) ],
        // generationConfig: GenerationConfig(...),
      );
    } else {
      // Handle the case where the API key is missing
      debugPrint("Error: GEMINI_API_KEY not found in .env file.");
    }
  }

  // Fetches a script based on user input
  Future<String?> generateScript(String userInput) async {
    // Check if the model was initialized successfully
    if (_model == null) {
      return "Script generator service not available (API Key missing or invalid).";
    }
    if (userInput.isEmpty) return "Please enter a valid prompt!";

    try {
      // Using startChat is fine for simple back-and-forth.
      // For single-turn generation, you could also use _model.generateContent directly.
      final chat = _model!.startChat();
      final response = await chat.sendMessage(Content.text(userInput));

      // Good practice: Check if response.text is actually non-null
      final text = response.text;
      if (text == null) {
        debugPrint("Warning: Received null text response from model.");
        return "Model returned no text. Please try again.";
      }
      return text.trim();
    } catch (error) {
      // Check for specific API errors if possible (e.g., quota, invalid arguments)
      debugPrint("Error generating script: $error");
      // Provide a more user-friendly error message
      if (error is GenerativeAIException) {
        // You can potentially check error.message for more specifics
        return "Failed to generate script: An API error occurred (${error.message}).";
      }
      return "Failed to generate script due to an unexpected error. Please try again.";
    }
  }
}
