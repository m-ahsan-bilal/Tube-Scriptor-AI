// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:go_router/go_router.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:tube_scriptor_ai/widgets/vertical_slider.dart';

// class PhotoScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   const PhotoScreen(this.cameras, {super.key});

//   @override
//   State<PhotoScreen> createState() => _PhotoScreenState();
// }

// class _PhotoScreenState extends State<PhotoScreen> {
//   CameraController? controller;
//   bool isCapturing = false;
//   int _selectedCameraIndex = 0;
//   bool _isFrontCamera = false;
//   bool _isFlashOn = false;
//   Offset? _focusPoint;
//   double _currentZoom = 1.0;
//   File? _capturedImage;
//   int cameraIndex = 0;
//   final double _brightness = 0.5; // Brightness control
//   final player = AudioPlayer(); // Audio player for shutter sound

//   @override
//   void initState() {
//     super.initState();
//     _initCamera(_selectedCameraIndex);
//   }

//   Future<void> _initCamera(int selectedCameraIndex) async {
//     if (!mounted) return; // Ensure the widget is still mounted

//     // Dispose the previous controller if it exists
//     if (controller != null && controller!.value.isInitialized) {
//       await controller!.dispose();
//     }

//     // Initialize the new camera controller
//     controller = CameraController(
//       widget.cameras[selectedCameraIndex],
//       ResolutionPreset.max,
//     );

//     try {
//       await controller!.initialize();
//       if (!mounted) return; // Ensure the widget is still mounted
//       setState(() {
//         _isFrontCamera = selectedCameraIndex == 1;
//       });
//     } catch (e) {
//       debugPrint("❌ Camera Initialization Error: $e");
//     }
//   }

//   void _toggleFlashLight() {
//     if (controller == null || !controller!.value.isInitialized) return;

//     if (_isFlashOn) {
//       controller!.setFlashMode(FlashMode.off);
//     } else {
//       controller!.setFlashMode(FlashMode.torch);
//     }
//     setState(() => _isFlashOn = !_isFlashOn);
//   }

//   void _switchCamera() async {
//     if (!mounted) return; // Ensure the widget is still mounted

//     // Dispose the current controller
//     if (controller != null && controller!.value.isInitialized) {
//       await controller!.dispose();
//     }

//     // Switch to the next camera
//     _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
//     await _initCamera(_selectedCameraIndex);
//   }

//   Future<void> capturePhoto() async {
//     if (controller == null ||
//         !controller!.value.isInitialized ||
//         controller!.value.isTakingPicture) {
//       return;
//     }

//     try {
//       setState(() => isCapturing = true);
//       final XFile capturedImage = await controller!.takePicture();
//       String imagePath = capturedImage.path;
//       await GallerySaver.saveImage(imagePath);
//       debugPrint("📸 Photo Captured & Saved: $imagePath");

//       // Play shutter sound effect
//       try {
//         await player.setAsset('assets/camera_shutter.mp3');
//         await player.play();
//       } catch (e) {
//         debugPrint("❌ Audio Player Error: $e");
//       }

//       setState(() {
//         _capturedImage = File(imagePath);
//       });
//     } catch (e) {
//       debugPrint("❌ Capture Error: $e");
//     } finally {
//       setState(() => isCapturing = false);
//     }
//   }

//   void zoomCamera(double value) {
//     if (controller == null || !controller!.value.isInitialized) return;

//     setState(() {
//       _currentZoom = value;
//       controller!.setZoomLevel(value);
//     });
//   }

//   Future<void> _setFocusPoint(Offset point) async {
//     if (controller == null || !controller!.value.isInitialized) return;

//     try {
//       final double x = point.dx.clamp(0.0, 1.0);
//       final double y = point.dy.clamp(0.0, 1.0);
//       await controller!.setFocusPoint(Offset(x, y));

//       setState(() {
//         _focusPoint = Offset(x, y);
//       });

//       await Future.delayed(Duration(seconds: 2));
//       setState(() {
//         _focusPoint = null;
//       });
//     } catch (e) {
//       debugPrint("❌ Focus Error: $e");
//     }
//   }

//   @override
//   void dispose() {
//     if (controller != null && controller!.value.isInitialized) {
//       controller!.dispose();
//     }
//     player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Stack(
//           children: [
//             // Camera Preview
//             if (controller != null && controller!.value.isInitialized)
//               Positioned.fill(
//                 child: GestureDetector(
//                   onTapDown: (TapDownDetails details) {
//                     _setFocusPoint(details.localPosition);
//                   },
//                   child: CameraPreview(controller!),
//                 ),
//               ),

//             // Back Button
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(.8),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         _isFlashOn ? Icons.flash_on : Icons.flash_off,
//                         color: Colors.white,
//                         size: 25,
//                         opticalSize: 20,
//                       ),
//                       onPressed: _toggleFlashLight,
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         Icons.close_outlined,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                       onPressed: () => context.go('/scriptor'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Zoom Slider

//             // Positioned(
//             //   right: 20,
//             //   top: 100,
//             //   bottom: 100,
//             //   child: VerticalSlider(
//             //     min: 1.0,
//             //     max: 10.0,
//             //     onChanged: (value) async {
//             //       setState(() {
//             //         _currentZoom = value;
//             //       });
//             //       await widget.controller.setZoomLevel(_zoomLevel);
//             //     },
//             //   ),
//             // ),
//             Positioned(
//               right: 100,
//               left: 100,
//               bottom: 150,
//               child: RotatedBox(
//                 quarterTurns: 1,
//                 child: SfSlider.vertical(
//                   min: 1.0,
//                   max: 3.0,
//                   activeColor: Colors.white60,
//                   value: _currentZoom,
//                   onChanged: (dynamic value) {
//                     zoomCamera(value);
//                   },
//                 ),
//               ),
//             ),

//             // Focus Indicator
//             if (_focusPoint != null)
//               Positioned(
//                 top: _focusPoint!.dy * MediaQuery.of(context).size.height,
//                 left: _focusPoint!.dx * MediaQuery.of(context).size.width,
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white, width: 2),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),

//             // Bottom Controls
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: 140,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.7),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Captured Image/Video Preview
//                       _capturedImage != null
//                           ? Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 border:
//                                     Border.all(color: Colors.black87, width: 1),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Image.file(
//                                 _capturedImage!,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 border:
//                                     Border.all(color: Colors.black87, width: 1),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),

//                       // Shutter Button
//                       Center(
//                         child: GestureDetector(
//                           onTap: capturePhoto,
//                           child: Container(
//                             width: 70,
//                             height: 70,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 2,
//                               ),
//                             ),
//                             child: Icon(
//                               Icons.camera,
//                               color: Colors.white,
//                               size: 40,
//                             ),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.cameraswitch, color: Colors.white),
//                         onPressed: _switchCamera,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
