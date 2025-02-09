import 'dart:io';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PhotoScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const PhotoScreen(this.cameras, {super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  late CameraController controller;
  bool isCapturing = false;
  int _selectedCameraIndex = 0;
  bool _isFrontCamera = false;
  bool _isFlashOn = false;
  Offset? _focusPoint;
  double _currentZoom = 1.0;
  File? _capturedImage;
  int cameraIndex = 0;

// audio pakcgae get for  sound effects
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

// flash light
  void _toggleFlashLight() {
    if (_isFlashOn) {
      controller.setFlashMode(FlashMode.off);
      setState(() {
        _isFlashOn = false;
      });
    } else {
      controller.setFlashMode(FlashMode.torch);
      setState(() {
        _isFlashOn = true;
      });
    }
  }

// switch camera back or front
  void _switchCamera() async {
    if (controller != null) {
      // dispose the current controller to release the sam resource
      await controller.dispose();
    }
    // increment or reset the selected camera index
    _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
    // iniliaze the new camera
    _initCamera(_selectedCameraIndex);
  }

// initiliaze the cam
  Future<void> _initCamera(int selectedCameraIndex) async {
    controller = CameraController(
        widget.cameras[selectedCameraIndex], ResolutionPreset.max);
    try {
      await controller.initialize();
      setState(() {
        _isFrontCamera = selectedCameraIndex == 1; // Change based on index
      });
    } catch (e) {
      debugPrint("Error Message: $e");
    }
    if (mounted) {
      setState(() {});
    }
  }

//  photo click
  void capturePhoto() async {
    if (!controller.value.isInitialized) {
      return;
    }

    final Directory appDir =
        await pathProvider.getApplicationDocumentsDirectory();
    final String capturePath = path.join(appDir.path, '${DateTime.now()}.jpg');

    if (controller.value.isTakingPicture) {
      return;
    }

    try {
      setState(() {
        isCapturing = true;
      });
      final XFile capturedImage = await controller.takePicture();
      String imagePath = capturedImage.path;
      await GallerySaver.saveImage(imagePath);
      debugPrint(" photi captures and saved in gallery");
      // play shutter sound effect
      await player.setAsset('assets/camera_shutter.mp3');
      player.play();
      debugPrint("Image Path: $imagePath");

      final String filePath =
          "$capturePath/${DateTime.now().millisecondsSinceEpoch}.jpg";
      _capturedImage = File(capturedImage.path);
      _capturedImage!.renameSync(filePath);
    } catch (e) {
      debugPrint("Error Message: $e");
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }

  // zoom camera
  void zoomCamera(double value) {
    setState(() {
      _currentZoom = value;
      controller.setZoomLevel(value);
    });
  }

// focus point

  Future<void> _setFocusPoint(Offset point) async {
    if (controller != null && controller.value.isInitialized) {
      try {
        final double x = point.dx.clamp(0.0, 1.0);
        final double y = point.dy.clamp(0.0, 1.0);
        await controller.setFocusPoint(Offset(x, y));
        await controller.setFocusPoint(FocusMode.auto as Offset?);
        setState(() {
          _focusPoint = Offset(x, y);
        });

        // Reset _focus point after 1 second to to remove the square

        await Future.delayed(Duration(seconds: 2));
        setState(() {
          _focusPoint = null;
        });
      } catch (e) {
        debugPrint("Error Message: $e");
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                              _toggleFlashLight();
                            },
                            child: _isFlashOn == false
                                ? Icon(
                                    Icons.flash_off,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.flash_on,
                                    color: Colors.white,
                                  )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              controller.value.isInitialized
                  ? Positioned.fill(
                      top: 40,
                      bottom: _isFrontCamera ? 150 : 0,
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              final Offset tapPosition = details.localPosition;
                              final Offset relativeTapPosition = Offset(
                                tapPosition.dx / constraints.maxWidth,
                                tapPosition.dx / constraints.maxHeight,
                              );
                              _setFocusPoint(relativeTapPosition);
                            },
                            child: CameraPreview(controller)),
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
              Positioned(
                top: 50,
                right: 10,
                child: SfSlider.vertical(
                  min: 1.0,
                  max: 5.0,
                  activeColor: Colors.white,
                  value: _currentZoom,
                  onChanged: (dynamic value) {
                    setState(() {
                      zoomCamera(value);
                    });
                  },
                ),
              ),
              _focusPoint != null
                  ? Positioned.fill(
                      top: 50,
                      child: Align(
                        alignment: Alignment(
                          _focusPoint!.dx * 2 - 1,
                          _focusPoint!.dy * 2 - 1,
                        ),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white10, width: 2),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 1,
                    ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: _isFrontCamera ? Colors.black45 : Colors.black,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Video",
                                style: TextStyle(color: Colors.white)),
                            Text("Photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text("Pro Mode",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _capturedImage != null
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        child: Image.file(
                                          _capturedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(),
                              ],
                            )),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  capturePhoto();
                                },
                                child: Center(
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                _switchCamera();
                              },
                              child: Icon(
                                Icons.cameraswitch_sharp,
                                color: Colors.white,
                                size: 40.0,
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
