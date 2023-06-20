import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:studycase2/Screen/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

List<CameraDescription> cameras = [];
List<Widget> imageWidgets = []; // List to store image widgets

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      title: 'Camera App 3000',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
      //routing to camera.dart
      routes: {
        '/camera': (context) => camera(
              camera: cameras.first,
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // void _takePicture(BuildContext context, String imagePath) {
  //   setState(() {
  //     imageWidgets.add(Image.file(File(imagePath)));
  //     if (imageWidgets.length > 10) {
  //       imageWidgets.removeAt(0);
  //     }
  //   });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App 3000'),
      ),
      body: Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Handle home button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {
                // navigate to camera.dart when account_circle is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => camera(
                      camera: cameras.first,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
