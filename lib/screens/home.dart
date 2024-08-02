import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kabegami_resize/screens/about.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kabegami_resize/utils/get_greeting.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'editor/image_edit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? image;
  final imagePicker = ImagePicker();
  bool _isLoading = false;

  Future getImageFromGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      if (!mounted) return;
      if (pickedFile != null) {
        image = XFile(pickedFile.path);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageEdit(imageFile: File(image!.path)),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('壁紙リサイズ'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${getGreeting()}, User!',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : getImageFromGallery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  icon: const Icon(Symbols.image_search),
                  label: const Text('画像を読み込む'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => const About()));
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  icon: const Icon(Symbols.info),
                  label: const Text('このアプリについて'),
                )
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Theme.of(context).colorScheme.scrim.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}