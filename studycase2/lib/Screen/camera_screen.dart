import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  void uploadFile(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Preview')),
      body: Container(
        width: 1080,
        height: 1920,
        child: GestureDetector(
          child: Stack(
            children: [
              Expanded(
                child: Image.file(File(imagePath)),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.large(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      uploadFile();//function untuk upload file lah kimak punya is
                    },
                    child: const Icon(Icons.upload, color: Colors.black),
                  )
                )
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
