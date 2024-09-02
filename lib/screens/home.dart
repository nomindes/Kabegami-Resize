import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kabegami_resize/screens/about.dart';
import 'package:image_picker/image_picker.dart';
import 'editor/image_edit.dart';
import 'package:iconsax/iconsax.dart';

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
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
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
      backgroundColor: const Color(0xFFBFBFBF),
      appBar: AppBar(
        title: const Text(
          'Kabegami Resize',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Lexend_Deca'),
        ),
        backgroundColor: const Color(0xFFE6E6E6),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : getImageFromGallery,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6E6E6),
                      foregroundColor: const Color(0xFF000000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 15,
                      shadowColor: const Color.fromARGB(100, 0, 0, 0)),
                  icon: const Icon(
                    Iconsax.gallery_add,
                    size: 20,
                  ),
                  label: const Text(
                    'Pick an image',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: 'Lexend_Deca'),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const About()));
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6E6E6),
                      foregroundColor: const Color(0xFF000000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 15,
                      shadowColor: const Color.fromARGB(100, 0, 0, 0)),
                  icon: const Icon(
                    Iconsax.message_question,
                    size: 20,
                  ),
                  label: const Text(
                    'About',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: 'Lexend_Deca'),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Developer\nX: @nomin_coding',
                  style: TextStyle(
                      fontFamily: 'Lexend_Deca',
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                )
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
