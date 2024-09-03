import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:path_provider/path_provider.dart';

class ImageAfterEdit extends StatefulWidget {
  final Uint8List croppedImageData;

  const ImageAfterEdit({super.key, required this.croppedImageData});

  @override
  State<ImageAfterEdit> createState() => _ImageAfterEditState();
}

class _ImageAfterEditState extends State<ImageAfterEdit> {
  bool _isLoading = false;

  Future<void> _saveImage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ImageGallerySaver.saveImage(widget.croppedImageData);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('保存されました')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _setWallpaper() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/wallpaper.png';

      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(widget.croppedImageData);

      bool result = await WallpaperManager.setWallpaperFromFile(
        imagePath,
        WallpaperManager.HOME_SCREEN,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result ? '壁紙を設定しました' : '壁紙の設定に失敗しました'),
          ),
        );
      }

      await imageFile.delete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFBFBFBF),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Iconsax.arrow_left_2),
            ),
            backgroundColor: const Color(0xFFE6E6E6),
            title: const Text(
              'Preview',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: 'Lexend_Deca'),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
                        color: Colors.white,
                        strokeWidth: 5,
                        dashPattern: const [10, 5],
                        child: Image.memory(widget.croppedImageData)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE6E6E6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 15,
                        shadowColor: const Color.fromARGB(100, 0, 0, 0),
                      ),
                      onPressed: _isLoading ? null : _setWallpaper,
                      child: const Text(
                        'Set as Wallpaper',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: 'Lexend_Deca',
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6E6E6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 15,
                          shadowColor: const Color.fromARGB(100, 0, 0, 0),
                        ),
                        onPressed: _isLoading ? null : _saveImage,
                        child: const Text(
                          'Save wallpaper',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'Lexend_Deca',
                              color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
    );
  }
}
