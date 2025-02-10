import 'dart:io';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class VideoScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const VideoScreen(this.cameras, {super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late CameraController controller;
  String _videoPath = "";
  bool _isRecording = false;
  bool isCapturing = false;
  int _selectedCameraIndex = 0;
  bool _isFrontCamera = false;
  bool _isFlashOn = false;
  Offset? _focusPoint;
  double _currentZoom = 1.0;
  File? _capturedImage;
  int cameraIndex = 0;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initCamera(_selectedCameraIndex);
  }

  Future<void> _initCamera(int selectedCameraIndex) async {
    controller = CameraController(
        widget.cameras[selectedCameraIndex], ResolutionPreset.max);
    try {
      await controller.initialize();
      setState(() {
        _isFrontCamera = selectedCameraIndex == 1;
      });
    } catch (e) {
      debugPrint("Error Message: $e");
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleFlashLight() {
    if (_isFlashOn) {
      controller.setFlashMode(FlashMode.off);
    } else {
      controller.setFlashMode(FlashMode.torch);
    }
    setState(() => _isFlashOn = !_isFlashOn);
  }

  void _switchCamera() async {
    if (controller != null) await controller.dispose();
    _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
    await _initCamera(_selectedCameraIndex);
  }

  void zoomCamera(double value) {
    setState(() {
      _currentZoom = value;
      controller.setZoomLevel(value);
    });
  }

  Future<void> _setFocusPoint(Offset point) async {
    if (!controller.value.isInitialized) return;

    try {
      final double x = point.dx.clamp(0.0, 1.0);
      final double y = point.dy.clamp(0.0, 1.0);
      await controller.setFocusPoint(Offset(x, y));

      setState(() {
        _focusPoint = Offset(x, y);
      });

      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _focusPoint = null;
      });
    } catch (e) {
      debugPrint("Error Message: $e");
    }
  }

  void toggleRecording() {
    if (_isRecording) {
      _stopVideoRecording();
    } else {
      _startVideoRecording();
    }
  }

  void _startVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      final directory = await getTemporaryDirectory();
      final path = "${directory.path}./video_${DateTime.now().millisecond}.mp4";

      try {
        await controller.startVideoRecording();
        setState(() {
          _isRecording = true;
          _videoPath = path;
        });
      } catch (e) {
        debugPrint("Error message $e");
        return;
      }
    }
  }

  void _stopVideoRecording() async {
    if (controller.value.isRecordingVideo) {
      try {
        final XFile videoFile = await controller.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });
        if (_videoPath.isNotEmpty) {
          final File file = File(videoFile.path);
          await file.copy(_videoPath);
          await GallerySaver.saveVideo(_videoPath);
          // play a sound effect
          player.setAsset('assets/music/.mp3');
          player.play();
        }
      } catch (e) {
        debugPrint("Error message: $e");
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
                                  toggleRecording();
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
                                      child: _isRecording == false
                                          ? Icon(
                                              Icons.play_arrow_outlined,
                                              color: Colors.white,
                                              size: 40,
                                            )
                                          : Icon(
                                              Icons.stop_circle_outlined,
                                              color: Colors.white,
                                              size: 40,
                                            )),
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
