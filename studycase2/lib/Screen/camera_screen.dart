import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Picture Preview')),
    body: Container(
      width: 1080,
      height: 1920,
      child: GestureDetector(
        child: Image.file(File(imagePath)),
        onDoubleTap: (){
          Navigator.pop(context);
        }
      )
      //Image.file(File(imagePath)),
    ),
  );
}
}