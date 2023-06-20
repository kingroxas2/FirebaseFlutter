import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart'; // Add this import statement
import 'package:studycase2/Screen/camera_screen.dart';
import '../main.dart';

class camera extends StatefulWidget {
  const camera({Key? key, required CameraDescription camera}) : super(key: key);

  @override
  _cameraState createState() => _cameraState();
}

class _cameraState extends State<camera> {
  late CameraController _controller;
  final int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize the camera controller
    _controller = CameraController(
      cameras[_selectedCameraIndex],
      ResolutionPreset.veryHigh,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    final appDirectory =
        await getApplicationDocumentsDirectory(); // Update this line
    final pictureDirectory = '${appDirectory.path}/Pictures';
    await Directory(pictureDirectory).create(recursive: true);
    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final filePath = '$pictureDirectory/$currentTime.jpg';

    try {
      await _controller.takePicture();
      // Do something with the captured picture (e.g., save it to Firebase or display it in another screen)
      print('Picture saved at: $filePath');
    } catch (e) {
      print('Error occurred while taking a picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
    appBar: AppBar(
      title: const Text('Camera App 3000'),
    ),
    body: Container(
      width: double.infinity,
      height: double.infinity,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final aspectRatio = constraints.maxWidth / constraints.maxHeight;

      return Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90,
              width: 90,
              margin: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton.large(
                backgroundColor: Colors.white,
                child: const Icon(Icons.camera_alt, color: Colors.black),
                onPressed: () async {
                  try {
                    final image = await _controller.takePicture();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          imagePath: image.path,
                        ),
                      ),
                    );
                    if (!mounted) return;
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ),
        ],
      );
        },
      ),
    ),
  );

  }
}
