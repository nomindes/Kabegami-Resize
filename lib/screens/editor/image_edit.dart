import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kabegami_resize/screens/editor/image_after_edit.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:material_symbols_icons/symbols.dart';

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
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      FileImage(widget.imageFile),
    );
    setState(() {
      _backgroundColor = paletteGenerator.dominantColor?.color ?? Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('画像編集'),
      ),
      body: Stack(
        children: [
          CustomImageCrop(
            cropController: _cropController,
            image: FileImage(widget.imageFile),
            ratio: Ratio(width: 1, height: 1 / aspectRatio),
            shape: CustomCropShape.Square,
            backgroundColor: _backgroundColor,
            canRotate: false,
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
      floatingActionButton: _isLoading ? null : Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'Crop',
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              final image = await _cropController.onCropImage();
              if(image != null && context.mounted) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageAfterEdit(croppedImageData: image.bytes)));
              }
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: const Icon(Symbols.crop),
          ),
          const SizedBox(height: 5),
          FloatingActionButton(
            heroTag: 'ColorPicker',
            onPressed: () {
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
            child: const Icon(Symbols.color_lens),
          ),
          const SizedBox(height: 5),
          FloatingActionButton(
            heroTag: 'AutoColor',
            onPressed: _extractDominantColor,
            child: const Icon(Symbols.auto_fix),
          ),
          const SizedBox(height: 5),
          FloatingActionButton(
            heroTag: 'Move to center',
            onPressed: () {
              _cropController.setData(CropImageData(x: 0, y: 0, scale: _cropController.cropImageData!.scale.toDouble()));
            },
            child: const Icon(Symbols.recenter),
          ),
          const SizedBox(height: 5),
          FloatingActionButton(
            heroTag: 'Reset',
            onPressed: () {
              _cropController.setData(CropImageData(x: 0, y: 0, angle: 0, scale: 1,));
              setState(() {
                _backgroundColor = Colors.white;
              });
            },
            child: const Icon(Symbols.reset_settings),
          ),
        ],
      ),
    );
  }
}