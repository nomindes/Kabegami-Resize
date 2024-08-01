import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('保存されました'))
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
          appBar: AppBar(
            title: const Text('プレビュー'),
          ),
          body: Center(
            child: Image.memory(widget.croppedImageData),
          ),
          floatingActionButton: Column(
            verticalDirection: VerticalDirection.up,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveImage,
                icon: const Icon(Icons.download),
                label: const Text('保存する'),
              ),
              const SizedBox(height: 5,),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _setWallpaper,
                icon: const Icon(Icons.wallpaper),
                label: const Text('壁紙にする'),
              ),
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
    );
  }
}