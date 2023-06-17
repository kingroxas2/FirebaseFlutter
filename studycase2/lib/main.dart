import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart'; // Add this import statement

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve the available cameras
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Camera App 3000',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController _controller;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize the camera controller
    _controller = CameraController(
      cameras[_selectedCameraIndex],
      ResolutionPreset.medium,
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
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller),
      ),
    ),
    floatingActionButton: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        width: 90,
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.large(
          backgroundColor: Colors.white,
          child: const Icon(Icons.camera_alt, color: Colors.black),
          onPressed: () {},
        ),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Handle home button press
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              // Handle add button press
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Handle favorite button press
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Handle account button press
            },
          ),
        ],
      ),
    ),
  );
}


}
