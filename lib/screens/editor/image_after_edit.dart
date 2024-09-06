import 'dart:io';
import 'dart:ui' as ui;
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
  bool _preventLockScreenEnlargement = false;

  Future<void> _showWallpaperOptions() async {
    return showDialog(
      context: context,
      barrierDismissible: !_isLoading,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                AlertDialog(
                  backgroundColor: const Color(0xFFE6E6E6),
                  title: const Text(
                    '壁紙設定オプション',
                    style: TextStyle(fontFamily: 'Lexend_Deca'),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                          title: const Text(
                            'ホーム画面に設定',
                            style: TextStyle(fontFamily: 'Lexend_Deca'),
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            await _setWallpaper(WallpaperManager.HOME_SCREEN);
                          }),
                      ListTile(
                          title: const Text(
                            'ロック画面に設定',
                            style: TextStyle(fontFamily: 'Lexend_Deca'),
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            await _setWallpaper(WallpaperManager.LOCK_SCREEN);
                          }),
                      CheckboxListTile(
                        title: const Text(
                          'ロック画面拡大防止',
                          style: TextStyle(fontFamily: 'Lexend_Deca'),
                        ),
                        value: _preventLockScreenEnlargement,
                        onChanged: (bool? value) {
                          setState(() {
                            _preventLockScreenEnlargement = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '※ロック画面で壁紙が拡大される端末があります',
                        style: TextStyle(fontFamily: 'Lexend_Deca'),
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
          },
        );
      },
    );
  }

  Future<void> _showSaveOptions() async {
    return showDialog(
      context: context,
      barrierDismissible: !_isLoading,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                AlertDialog(
                  backgroundColor: const Color(0xFFE6E6E6),
                  title: const Text(
                    '壁紙保存オプション',
                    style: TextStyle(fontFamily: 'Lexend_Deca'),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text(
                          'そのまま保存',
                          style: TextStyle(fontFamily: 'Lexend_Deca'),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          await _saveImage(false);
                        },
                      ),
                      ListTile(
                        title: const Text(
                          '拡大防止版を保存',
                          style: TextStyle(fontFamily: 'Lexend_Deca'),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          await _saveImage(true);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '※ロック画面で壁紙が拡大される端末があります',
                        style: TextStyle(fontFamily: 'Lexend_Deca'),
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
          },
        );
      },
    );
  }

  Future<Uint8List> _addPaddingToImage(Uint8List imageData) async {
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final srcSize = Size(image.width.toDouble(), image.height.toDouble());
    final dstSize = Size(srcSize.width * 1.1, srcSize.height * 1.1);

    final srcRect = Rect.fromLTWH(0, 0, srcSize.width, srcSize.height);
    final dstRect = Rect.fromLTWH(
      (dstSize.width - srcSize.width) / 2,
      (dstSize.height - srcSize.height) / 2,
      srcSize.width,
      srcSize.height,
    );

    canvas.drawImageRect(image, srcRect, dstRect, Paint());

    final picture = recorder.endRecording();
    final img =
        await picture.toImage(dstSize.width.round(), dstSize.height.round());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _setWallpaper(int wallpaperType) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/wallpaper.png';

      Uint8List imageData = widget.croppedImageData;
      if (_preventLockScreenEnlargement &&
          wallpaperType == WallpaperManager.LOCK_SCREEN) {
        imageData = await _addPaddingToImage(widget.croppedImageData);
      }

      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageData);

      bool result = await WallpaperManager.setWallpaperFromFile(
        imagePath,
        wallpaperType,
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

  Future<void> _saveImage(bool addPadding) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Uint8List imageData = widget.croppedImageData;
      if (addPadding) {
        imageData = await _addPaddingToImage(widget.croppedImageData);
      }

      await ImageGallerySaver.saveImage(imageData);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('保存されました')));
      }
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
    return IgnorePointer(
      ignoring: _isLoading,
      child: Stack(
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
                        onPressed: _showWallpaperOptions,
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
                        width: 5,
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
                          onPressed: _showSaveOptions,
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
      ),
    );
  }
}
