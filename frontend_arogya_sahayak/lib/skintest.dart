import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui'; // For the blur effect
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class SkinTest extends StatefulWidget {
  @override
  _SkinTestState createState() => _SkinTestState();
}

class _SkinTestState extends State<SkinTest> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  late CameraDescription firstCamera;
  late CameraDescription secondCamera;
  final AudioCache player = AudioCache();
  // For controlling flash mode

  bool isUsingFirstCamera = true;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras!.length > 0) {
        firstCamera = cameras![0];
        if (cameras!.length > 1) {
          secondCamera = cameras![1];
        }
        _initializeCamera(firstCamera);
      }
    }).catchError((err) {
      print('Error: $err');
    });
  }

  void _initializeCamera(CameraDescription cameraDescription) {
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  bool isTorchOn = false;

  FlashMode flashMode = FlashMode.off;

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }
    try {
      await controller!.setFlashMode(mode);
      setState(() {
        flashMode = mode;
      });
    } on CameraException catch (e) {
      print('Error: ${e.code}\n${e.description}');
    }
  }

  void _switchCamera() {
    if (isUsingFirstCamera && cameras!.length > 1) {
      _initializeCamera(secondCamera);
      isUsingFirstCamera = false;
    } else {
      _initializeCamera(firstCamera);
      isUsingFirstCamera = true;
    }
  }

  Future<void> _focusPoint(TapDownDetails details) async {
    if (controller == null || !controller!.value.isInitialized || controller!.value.focusMode == FocusMode.locked) {
      return;
    }
    final focusPoint = Offset(details.localPosition.dx / MediaQuery.of(context).size.width, details.localPosition.dy / MediaQuery.of(context).size.height);
    await controller!.lockCaptureOrientation();
    await controller!.setFocusMode(FocusMode.auto);
    await Future.delayed(Duration(seconds: 1));
    await controller!.unlockCaptureOrientation();
  }

  Future<void> _showImagePreview(String path) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.file(File(path)),
          actions: [
            ElevatedButton(
              child: Text("Retake"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () {
                Navigator.of(context).pop();  // Close the image preview dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SpinKitCircle(color: Colors.blue),
                    );
                  },
                );
                _submitImage(path);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitImage(String path) async {
    try {
      final Uri apiUrl = Uri.parse('http://20.192.10.30/skin');
      final request = http.MultipartRequest('POST', apiUrl);
      request.files.add(await http.MultipartFile.fromPath('image', path));

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseData = jsonDecode(responseBody);

        Navigator.of(context).pop();  // Close the loading dialog

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Predicted Disease: ${responseData['result']}"),
              actions: [
                ElevatedButton(
                  child: Text("Home"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog for now
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to upload image.');
      }
    } catch (e) {
      print("Failed uploading image: $e");
      Navigator.of(context).pop();  // Close the loading dialog

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred while uploading the image."),
            actions: [
              ElevatedButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTapUp: (details) => _focusPoint(details.localPosition as TapDownDetails),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 1.00,
              height: MediaQuery.of(context).size.height * 0.80,
              child: CameraPreview(controller!),
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width * 0.42,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: IconButton(
                icon: Icon(Icons.camera_alt, size: 28),
                onPressed: () async {
                  player.play('shutter.mp3');
                  final XFile file = await controller!.takePicture();
                  _showImagePreview(file.path);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width * 0.7,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: IconButton(
                icon: Icon(Icons.switch_camera, size: 24),
                onPressed: _switchCamera,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width * 0.1,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: IconButton(
                icon: Icon(
                  controller!.value.flashMode == FlashMode.torch
                      ? Icons.flash_on
                      : controller!.value.flashMode == FlashMode.auto
                      ? Icons.flash_auto
                      : Icons.flash_off,
                  size: 24,
                ),
                onPressed: () {
                  if (flashMode == FlashMode.off) {
                    setFlashMode(FlashMode.auto);
                  } else if (flashMode == FlashMode.auto) {
                    setFlashMode(FlashMode.torch);
                  } else {
                    setFlashMode(FlashMode.off);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
