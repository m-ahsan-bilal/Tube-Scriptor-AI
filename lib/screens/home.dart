import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app resources/app_resources.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppResources.colors.gradient2),
      child: Scaffold(
        backgroundColor: AppResources.colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppResources.colors.purpleColor,
          bottomOpacity: 2.5,
          elevation: 4.9,
          shadowColor: Colors.black,
          title: Text(
            "Home Page",
            style:
                TextStyle(fontSize: 16, color: AppResources.colors.lightPurple),
          ),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () => context.go('/scriptor'),
              child: Text(
                " Script Page ",
              )),
        ),
      ),
    );
  }
}
