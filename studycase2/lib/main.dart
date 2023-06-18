import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:studycase2/Screen/camera_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve the available cameras
  cameras = await availableCameras();

  runApp(const MyApp());
}


Future<String> saveImage(XFile imageFile) async {
  final directory = await getExternalStorageDirectory();
  final dcimDirectory = Directory('${directory!.path}/DCIM');
  await dcimDirectory.create(recursive: true);

  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  final filePath = '${dcimDirectory.path}/$fileName.png';

  final File file = File(imageFile.path);
  await file.copy(filePath);

  return filePath;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Camera App 3000',
      theme: ThemeData(
        primarySwatch: Colors.teal,
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
          onPressed: () async{
            try {
              final image = await _controller.takePicture();
              await saveImage(image);
              //ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: image.path,),
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
