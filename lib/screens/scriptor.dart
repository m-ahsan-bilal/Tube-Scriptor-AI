import 'package:flutter/material.dart';
import 'package:tube_scriptor_ai/utils/app%20resources/app_resources.dart';

class ScriptorPage extends StatelessWidget {
  const ScriptorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppResources.colors.gradient1),
      child: Scaffold(
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
