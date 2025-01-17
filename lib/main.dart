import 'package:flutter/material.dart';
import 'package:tube_scriptor_ai/utils/go_router.dart';

void main() async {
  runApp(
    MyApp(),
  );

  // // initialize the model in app
  // final model = GenerativeModel(
  //     model: "gemini-pro", apiKey: "AIzaSyChd40HjxUtB0FXNqXh-FuGp2duXDpcGrQ");
  // final content = [
  //   Content.text(
  //     "how to better of yourself in 6 months youtube video script",
  //   )
  // ];
  // final response = await model.generateContent(content);
  // debugPrint(response.text);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: basicRoutes,
    );
  }
}
