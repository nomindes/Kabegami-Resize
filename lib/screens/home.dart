import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kabegami_resize/screens/about.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kabegami_resize/utils/get_greeting.dart';
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
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${getGreeting()}, User!',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10,),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : getImageFromGallery,
                  label: const Text('画像を読み込む'),
                  icon: const Icon(Icons.image_search),
                ),
                const SizedBox(height: 5),
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
                  label: const Text('このアプリについて'),
                  icon: const Icon(Icons.info),
                )
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}