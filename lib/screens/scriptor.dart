import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tube_scriptor_ai/models/api_service.dart';
import '../utils/app resources/app_resources.dart';

class ScriptorPage extends StatefulWidget {
  const ScriptorPage({super.key});

  @override
  State<ScriptorPage> createState() => _ScriptorPageState();
}

class _ScriptorPageState extends State<ScriptorPage> {
  final scriptController = TextEditingController();
  final ScriptGeneratorService _scriptService =
      ScriptGeneratorService(); // Initialize API service

  String? generatedScript;
  bool isLoading = false;

  /// Fetch script using the new service class
  Future<void> generateScript() async {
    final userInput = scriptController.text.trim();

    if (userInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a prompt!")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedScript = null;
    });

    // Call API using the new class
    String? response = await _scriptService.generateScript(userInput);

    setState(() {
      generatedScript = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppResources.colors.gradient1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Script Page"),
          backgroundColor: Colors.cyan,
          elevation: 0.7,
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.go("/cam"),
            label: const Icon(Icons.camera_alt_sharp)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    "Generate your YouTube scripts in one click!",
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 100),
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
                totalRepeatCount: 1,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: scriptController,
                decoration: const InputDecoration(
                  hintText: 'Enter your prompt here!',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : generateScript,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Generate Script"),
                ),
              ),
              const SizedBox(height: 16),
              if (generatedScript != null) ...[
                const Divider(),
                const Text(
                  "Generated Script:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      generatedScript!,
                      style: const TextStyle(fontSize: 16),
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
