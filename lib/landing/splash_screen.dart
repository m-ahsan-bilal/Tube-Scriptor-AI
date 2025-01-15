import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app resources/app_resources.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => context.go('/home'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(gradient: AppResources.colors.gradient2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Tube Scriptor Ai",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppResources.colors.blackText),
            ),
            Text(
              "Developed By: Muhammad Ahsan",
              style: TextStyle(color: AppResources.colors.blueGrey),
            )
          ],
        ),
      ),
    );
  }
}
