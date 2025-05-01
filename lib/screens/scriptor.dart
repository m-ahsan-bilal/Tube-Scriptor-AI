import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tube_scriptor_ai/models/api_service.dart';
import 'package:tube_scriptor_ai/widgets/dropdown.dart';

import '../utils/app resources/app_resources.dart';

class ScriptorPage extends StatefulWidget {
  const ScriptorPage({super.key});

  @override
  State<ScriptorPage> createState() => _ScriptorPageState();
}

class _ScriptorPageState extends State<ScriptorPage> {
  // keys

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // controllerrs
  final scriptController = TextEditingController();

  // services
  final ScriptGeneratorService _scriptService = ScriptGeneratorService();
  //  variables
  String? generatedScript;
  bool isLoading = false;

  final ItemScrollController _scrollController = ItemScrollController();

  // Dropdown selections
  String selectedTone = "Professional";
  String selectedStyle = "Storytelling";
  String selectedLength = "Short (1-2 min)";
  String selectedAgeGroup = "18-25";
  String selectedVideoType = "Explainer";

  // Dropdown options
  final List<String> toneOptions = [
    "Professional",
    "Casual",
    "Exciting",
    "Inspirational",
  ];
  final List<String> styleOptions = [
    "Storytelling",
    "Educational",
    "Persuasive",
    "Conversational",
  ];
  final List<String> lengthOptions = [
    "Short (1-2 min)",
    "Medium (3-5 min)",
    "Long (6+ min)",
  ];
  final List<String> ageGroupOptions = [
    "12-17",
    "18-25",
    "30-40",
    "40-45",
    "46+",
  ];
  final List<String> videoTypeOptions = [
    "Explainer",
    "Tutorial",
    "Review",
    "Vlog",
    "Interview",
  ];

  @override
  void initState() {
    super.initState();
    // print deafult values
    debugPrint("Selected Age Group: $selectedAgeGroup");
    debugPrint("Selected Video Type: $selectedVideoType");
    debugPrint("Age Group Options: $ageGroupOptions");
    debugPrint("Video Type Options: $videoTypeOptions");
  }

  // generate prompt
  String buildPrompt() {
    String topic = scriptController.text.trim();

    // Additional details for better script generation
    String additionalDetails =
        "Include a call-to-action at the end and use engaging visuals.";

    return """
I am a Youtuber and I want to create a video about $topic.
Generate a $selectedTone YouTube script in a $selectedStyle style 
for a video about '$topic'. The target audience is $selectedAgeGroup years old, and the video type is $selectedVideoType. 
Keep the length $selectedLength. $additionalDetails
""";
  }

  // Fetch script using the service class
  Future<void> generateScript() async {
    if (scriptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a topic!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedScript = null;
    });

    final String userPrompt = buildPrompt();

    // Call API using the service class
    String? response = await _scriptService.generateScript(userPrompt);

    setState(() {
      generatedScript = response;
      isLoading = false;
    });

    // Auto-scroll to response
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.scrollTo(
        index: 5,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
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
          backgroundColor: Colors.cyan,
          elevation: 0.7,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go("/video_screen"),
          label: const Icon(Icons.camera_alt_sharp),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ScrollablePositionedList.builder(
            itemCount: 6,
            itemScrollController: _scrollController,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated Title
                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          "Create Your YouTube Script Instantly!",
                          textStyle: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          speed: const Duration(milliseconds: 80),
                          curve: Curves.fastOutSlowIn,
                        ),
                      ],
                      totalRepeatCount: 1,
                    ),
                    const SizedBox(height: 16),

                    // Input Fields
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: scriptController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your video topic',
                          border: OutlineInputBorder(),
                        ),
                        onFieldSubmitted: (_) => generateScript(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            // return 'Please enter a topic';
                            ScaffoldMessenger(
                              child: const SnackBar(
                                content: Text("Please enter a topic!"),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppDropdown(
                      label: "Select Tone",
                      value: selectedTone,
                      items: toneOptions,
                      onChanged:
                          (value) => setState(() => selectedTone = value!),
                    ),
                    const SizedBox(height: 10),
                    AppDropdown(
                      label: "Select Style",
                      value: selectedStyle,
                      items: styleOptions,
                      onChanged:
                          (value) => setState(() => selectedStyle = value!),
                    ),
                    const SizedBox(height: 10),
                    AppDropdown(
                      label: "Select Length",
                      value: selectedLength,
                      items: lengthOptions,
                      onChanged:
                          (value) => setState(() => selectedLength = value!),
                    ),
                    const SizedBox(height: 10),
                    AppDropdown(
                      label: "Select Age Group",
                      value: selectedAgeGroup,
                      items: ageGroupOptions,
                      onChanged:
                          (value) => setState(() => selectedAgeGroup = value!),
                    ),
                    const SizedBox(height: 10),
                    AppDropdown(
                      label: "Select Video Type",
                      value: selectedVideoType,
                      items: videoTypeOptions,
                      onChanged:
                          (value) => setState(() => selectedVideoType = value!),
                    ),
                    const SizedBox(height: 16),
                    // Generate Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppResources.colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: generateScript,
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  "Generate Script",
                                  style: TextStyle(
                                    color: AppResources.colors.darkGrey,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                );
              } else if (index == 5 && generatedScript != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Generated Script:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          generatedScript!,
                          textStyle: const TextStyle(fontSize: 16),
                          speed: const Duration(milliseconds: 40),
                        ),
                      ],
                      repeatForever: false,
                      totalRepeatCount: 1,
                    ),
                  ],
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
