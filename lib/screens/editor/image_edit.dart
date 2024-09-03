import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kabegami_resize/screens/editor/image_after_edit.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageEdit extends StatefulWidget {
  final File imageFile;

  const ImageEdit({super.key, required this.imageFile});

  @override
  State<ImageEdit> createState() => _ImageEditState();
}

class _ImageEditState extends State<ImageEdit> {
  final _cropController = CustomImageCropController();
  bool _isLoading = false;
  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _extractDominantColor();
  }

  Future<void> _extractDominantColor() async {
    setState(() {
      _isLoading = true;
    });
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      FileImage(widget.imageFile),
    );
    setState(() {
      _backgroundColor = paletteGenerator.dominantColor?.color ?? Colors.white;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Scaffold(
      backgroundColor: _backgroundColor.withAlpha(130),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left_2),
        ),
        backgroundColor: const Color(0xFFE6E6E6),
        title: const Text(
          'Edit',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Lexend_Deca'),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: CustomImageCrop(
                  cropController: _cropController,
                  image: FileImage(widget.imageFile),
                  ratio: Ratio(width: 1, height: 1 / aspectRatio),
                  shape: CustomCropShape.Square,
                  backgroundColor: _backgroundColor,
                  canRotate: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  child: Card(
                    elevation: 15,
                    shadowColor: const Color.fromARGB(100, 0, 0, 0),
                    color: const Color(0xFFE6E6E6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _cropController.setData(CropImageData(
                                      x: 0,
                                      y: 0,
                                      angle: 0,
                                      scale: 1,
                                    ));
                                    setState(() {
                                      _backgroundColor = Colors.white;
                                    });
                                  },
                            icon: const Icon(
                              Iconsax.refresh,
                              size: 40,
                            )),
                        IconButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _cropController.setData(CropImageData(
                                        x: 0,
                                        y: 0,
                                        scale: _cropController
                                            .cropImageData!.scale
                                            .toDouble()));
                                  },
                            icon: const Icon(
                              Iconsax.maximize,
                              size: 40,
                            )),
                        IconButton(
                            onPressed:
                                _isLoading ? null : _extractDominantColor,
                            icon: const Icon(
                              Iconsax.magicpen,
                              size: 40,
                            )),
                        IconButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Pick a color!'),
                                            content: SingleChildScrollView(
                                              child: ColorPicker(
                                                pickerColor: _backgroundColor,
                                                onColorChanged: (Color color) {
                                                  setState(() {
                                                    _backgroundColor = color;
                                                  });
                                                },
                                              ),
                                            ),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: const Text('DONE'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                            icon: const Icon(
                              Iconsax.colorfilter,
                              size: 40,
                            )),
                        IconButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    final image =
                                        await _cropController.onCropImage();
                                    if (image != null && context.mounted) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageAfterEdit(
                                                      croppedImageData:
                                                          image.bytes)));
                                    }
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                            icon: const Icon(
                              Iconsax.crop,
                              size: 40,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
