import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:studycase2/Screen/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

List<CameraDescription> cameras = [];
List<Widget> imageWidgets = []; // List to store image widgets

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      title: 'Camera App 3000',
      theme: ThemeData(
        primarySwatch: Colors.teal,
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
      body: Container(
          child: Center(
        child: Text('Images will display here'),
      )),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Camera App 3000',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
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
