import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class GalleryScreen extends StatefulWidget {
  // const GalleryScreen({Key? key}) : super(key: key);
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  //File? file;
  final ImagePicker imagePicker = ImagePicker();
  AppState ? state;
  File ? imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (state == AppState.free)
            gallery();
          else if (state == AppState.picked)
            _cropImage();
          // else if (state == AppState.cropped) _clearImage();
        },
        child: _buildButtonIcon(),
      ),*/
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
          imageFile != null
              ? Expanded(
            flex: 9,
                child: Container(
            height: Get.height * 0.75,
            width: Get.width,
            child: imageFile != null
                  ? Image.file(
                  imageFile!, height: 100, width: 100, fit: BoxFit.fill)
                  : null,
          ),
              )
              : Container(
            child: Center(
              child: Text('No Image Selected', textScaleFactor: 1.3,),
            ),
          ),


          Expanded(
              flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        _cropImage();
                      },
                      icon: Icon(Icons.crop, color: Colors.blue, size: 30,))
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  void gallery() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = image != null ? File(image.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File ? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
        ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
        ]
        : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }
}
