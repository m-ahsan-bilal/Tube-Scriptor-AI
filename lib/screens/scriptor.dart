import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tube_scriptor_ai/utils/app%20resources/app_resources.dart';

class ScriptorPage extends StatefulWidget {
  const ScriptorPage({super.key});

  @override
  State<ScriptorPage> createState() => _ScriptorPageState();
}

class _ScriptorPageState extends State<ScriptorPage> {
  final scriptController = TextEditingController();
  final GenerativeModel model = GenerativeModel(
    model: "gemini-pro",
    apiKey: "AIzaSyChd40HjxUtB0FXNqXh-FuGp2duXDpcGrQ",
  );

  String? generatedScript;
  bool isLoading = false;

  Future<void> generateScript() async {
    final userInput = scriptController.text.trim();

    if (userInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a prompt!")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedScript = null;
    });

    try {
      final content = [Content.text(userInput)];
      final response = await model.generateContent(content);

      setState(() {
        generatedScript = response.text;
      });
    } catch (error) {
      setState(() {
        generatedScript = "Failed to generate script. Please try again.";
      });
      debugPrint("Error generating content: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppResources.colors.gradient1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Script Page"),
          backgroundColor: Colors.cyan,
          elevation: 0.7,
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.go("/cam"),
            label: Icon(Icons.camera_alt_sharp)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    "Generate your YouTube scripts in one click!",
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: Duration(milliseconds: 100),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
                totalRepeatCount: 1,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: scriptController,
                decoration: InputDecoration(
                  hintText: 'Enter your prompt here!',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : generateScript,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Generate Script"),
                ),
              ),
              SizedBox(height: 16),
              if (generatedScript != null) ...[
                Divider(),
                Text(
                  "Generated Script:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      generatedScript!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
