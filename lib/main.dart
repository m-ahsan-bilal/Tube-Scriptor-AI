import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tube_scriptor_ai/utils/go_router.dart';

List<CameraDescription> cameras = [];

void main() async {
  await dotenv.load(
    fileName: ".env",
  ); // Load the .env file in which we have api key
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  // final model = GenerativeModel(
  //   model: 'gemini-2.0-flash',
  //   apiKey: 'AIzaSyBNdy1tTySX1MmmIbXQoY4h8XCz7K3qBGI',
  // );

  // final prompt = [Content.text("Say hello in Urdu")];

  // try {
  //   final response = await model.generateContent(prompt);
  //   print(response.text);
  // } catch (e) {
  //   print("Error: $e");
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: basicRoutes,
    );
  }
}
