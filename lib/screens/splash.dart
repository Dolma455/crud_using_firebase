import 'package:flutter/material.dart';

class SPlashScreen extends StatelessWidget {
  const SPlashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Chat"),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
