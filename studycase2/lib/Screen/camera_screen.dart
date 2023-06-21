import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  UploadTask? _uploadTask;
  double _progress = 0.0;

  Future<void> uploadFile() async {
    try {
      // Create a reference to the image file in Firebase Storage
      String fileName = DateTime.now().toString();
      Reference reference =
          FirebaseStorage.instance.ref().child('images/$fileName');

      // Upload the file to Firebase Storage
      _uploadTask = reference.putFile(File(widget.imagePath));

      // Listen to the task state changes to track the progress
      _uploadTask!.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _progress =
              snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
        });
      });

      // Wait for the upload task to complete
      await _uploadTask!.whenComplete(() {
        print('File uploaded successfully');
        // Navigate back to the home page after the progress is complete
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });

      // Get the download URL of the uploaded file
      String downloadURL = await reference.getDownloadURL();

      // Print the download URL
      print('Download URL: $downloadURL');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Preview')),
      body: Container(
        width: 1080,
        height: 1920,
        child: Column(
          children: [
            Expanded(
              child: Image.file(File(widget.imagePath)),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: _progress),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.large(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    await uploadFile();
                  },
                  child: const Icon(Icons.upload, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
