import 'package:flutter/material.dart';
import 'package:kabegami_resize/widgets/about_md.dart';
import 'package:iconsax/iconsax.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6E6),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_2),
        ),
        title: const Text(
          'About this App',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Lexend_Deca'),
        ),
      ),
      body: AboutMd(),
    );
  }
}
