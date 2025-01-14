import 'package:flutter/material.dart';
import 'package:tube_scriptor_ai/utils/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: appRoutesList,
    
    );
  }
}
