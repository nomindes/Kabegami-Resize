import 'package:flutter/material.dart';
import 'package:kabegami_resize/widgets/about_md.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('このアプリについて'),
      ),
      body: const AboutMd(),
    );
  }
}
