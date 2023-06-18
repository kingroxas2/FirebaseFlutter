import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Preview')),
      body: Container(
        width: 1080,
        height: 1920,
        child: GestureDetector(
          child: Column(
            children: [
              Expanded(
                child: Image.file(File(imagePath)),
              ),
              const SizedBox(height: 10),
              Text(
                'Image Path: $imagePath',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          onDoubleTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
