import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tube_scriptor_ai/models/api_service.dart';

import '../utils/app resources/app_resources.dart';

class ScriptorPage extends StatefulWidget {
  const ScriptorPage({super.key});

  @override
  State<ScriptorPage> createState() => _ScriptorPageState();
}

class _ScriptorPageState extends State<ScriptorPage> {
  final scriptController = TextEditingController();
  final ScriptGeneratorService _scriptService = ScriptGeneratorService();

  String? generatedScript;
  bool isLoading = false;

  final ItemScrollController _scrollController = ItemScrollController();

  // Dropdown selections
  String selectedTone = "Professional";
  String selectedStyle = "Storytelling";
  String selectedLength = "Short (1-2 min)";
  String selectedAgeGroup =
      "18-25"; // Ensure this matches an item in ageGroupOptions
  String selectedVideoType =
      "Explainer"; // Ensure this matches an item in videoTypeOptions

  // Dropdown options
  final List<String> toneOptions = [
    "Professional",
    "Casual",
    "Exciting",
    "Inspirational"
  ];
  final List<String> styleOptions = [
    "Storytelling",
    "Educational",
    "Persuasive",
    "Conversational"
  ];
  final List<String> lengthOptions = [
    "Short (1-2 min)",
    "Medium (3-5 min)",
    "Long (6+ min)"
  ];
  final List<String> ageGroupOptions = [
    "13-17",
    "18-25",
    "26-35",
    "36-45",
    "46+"
  ];
  final List<String> videoTypeOptions = [
    "Explainer",
    "Tutorial",
    "Review",
    "Vlog",
    "Interview"
  ];

  @override
  void initState() {
    super.initState();
    // Debugging: Print initial values and options
    debugPrint("Selected Age Group: $selectedAgeGroup");
    debugPrint("Selected Video Type: $selectedVideoType");
    debugPrint("Age Group Options: $ageGroupOptions");
    debugPrint("Video Type Options: $videoTypeOptions");
  }

  /// Generate a full prompt based on user selections
  String buildPrompt() {
    String topic = scriptController.text.trim();

    // Additional details for better script generation
    String additionalDetails =
        "Include a call-to-action at the end and use engaging visuals.";

    return """
Generate a ${selectedTone.toLowerCase()} YouTube script in a ${selectedStyle.toLowerCase()} style 
for a video about '$topic'. The target audience is ${selectedAgeGroup} years old, and the video type is ${selectedVideoType}. 
Keep the length ${selectedLength.toLowerCase()}. $additionalDetails
""";
  }

  /// Fetch script using the service class
  Future<void> generateScript() async {
    final String userPrompt = buildPrompt();

    if (userPrompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a topic!")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      generatedScript = null;
    });

    // Call API using the service class
    String? response = await _scriptService.generateScript(userPrompt);

    setState(() {
      generatedScript = response;
      isLoading = false;
    });

    // Auto-scroll to response
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollController.scrollTo(
        index: 5,
        duration: Duration(seconds: 1),
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
          title: const Text("AI Script Generator"),
          backgroundColor: Colors.cyan,
          elevation: 0.7,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.go("/cam"),
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
                    TextFormField(
                      controller: scriptController,
                      decoration: const InputDecoration(
                        labelText: 'Enter your video topic',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dropdowns
                    DropdownButtonFormField<String>(
                      value: selectedTone,
                      decoration: InputDecoration(
                          labelText: "Select Tone",
                          fillColor: AppResources.colors.tealLight),
                      items: toneOptions.map((tone) {
                        return DropdownMenuItem(value: tone, child: Text(tone));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedTone = value!);
                      },
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedStyle,
                      decoration:
                          const InputDecoration(labelText: "Select Style"),
                      items: styleOptions.map((style) {
                        return DropdownMenuItem(
                            value: style, child: Text(style));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedStyle = value!);
                      },
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedLength,
                      decoration: InputDecoration(
                          labelText: "Select Length",
                          fillColor: AppResources.colors.tealLight,
                          hoverColor: Colors.black87),
                      items: lengthOptions.map((length) {
                        return DropdownMenuItem(
                            value: length, child: Text(length));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedLength = value!);
                      },
                    ),
                    const SizedBox(height: 10),

                    // Dropdown for Age Group
                    DropdownButtonFormField<String>(
                      value: selectedAgeGroup,
                      decoration: InputDecoration(
                          labelText: "Select Age Group",
                          fillColor: AppResources.colors.tealLight),
                      items: ageGroupOptions.map((ageGroup) {
                        return DropdownMenuItem(
                            value: ageGroup, child: Text(ageGroup));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedAgeGroup = value!);
                      },
                    ),
                    const SizedBox(height: 10),

                    // Dropdown for Video Type
                    DropdownButtonFormField<String>(
                      value: selectedVideoType,
                      decoration: InputDecoration(
                          labelText: "Select Video Type",
                          fillColor: AppResources.colors.tealLight),
                      items: videoTypeOptions.map((videoType) {
                        return DropdownMenuItem(
                            value: videoType, child: Text(videoType));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedVideoType = value!);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Generate Button
                    Center(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : generateScript,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Generate Script"),
                      ),
                    ),
                    const SizedBox(height: 16),
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
