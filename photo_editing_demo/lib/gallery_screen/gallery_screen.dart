import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GalleryScreen extends StatefulWidget {
  // const GalleryScreen({Key? key}) : super(key: key);
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}
class _GalleryScreenState extends State<GalleryScreen> {
  File? file;
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => gallery(),
            icon: Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),

      body: Column(
        children: [
          file != null
          ? Container(
            height:Get.height * 0.75,
            width: Get.width,
            child: file != null
                ? Image.file(file!, height: 100, width: 100, fit: BoxFit.fill)
                : null,
          )
          : Container(
            child: Center(
              child: Text('No Image Selected', textScaleFactor: 1.3,),
            ),
          ),
        ],
      ),
    );
  }

  void gallery() async {
      final image = await imagePicker.getImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          file = File(image.path);
        });
      } else {}
    }
}
