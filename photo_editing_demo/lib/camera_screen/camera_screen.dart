import 'dart:io';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as imageLib;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';


class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}
class _CameraScreenState extends State<CameraScreen> {
  File? file;
  final ImagePicker imagePicker = ImagePicker();
  List<Filter> filters = presetFiltersList;
  String? fileName;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => camera(),
            icon: Icon(Icons.camera_alt_rounded),
          ),
          IconButton(
            onPressed: () async {
              await saveImage();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: file != null
          ? Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: Container(
                      color: Colors.black,
                      width: Get.width,
                      child: file != null
                          ? Image.file(file!)
                          : null,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await _cropImage();
                          },
                          icon: Icon(Icons.crop),
                        ),
                        IconButton(
                          onPressed: () async {
                            await filterImage(context);
                          },
                          icon: Icon(Icons.filter_alt_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              child: Center(
                child: Text('No Image Selected', textScaleFactor: 1.3),
              ),
            ),
    );
  }

  // Getting Image From Camera
  void camera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    } else {}
  }

  // Add Filter in Image
  Future filterImage(context) async {
    fileName = basename(file!.path);
    var image = imageLib.decodeImage(file!.readAsBytesSync());
    image = imageLib.copyResize(image!, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Photo Filter Example"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName!,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
          circleShape: false,
        ),
      ),
    );
    if (imagefile.isNotEmpty && imagefile.containsKey('image_filtered')) {
      setState(() {
        file = imagefile['image_filtered'];
      });
      print(file!.path);
    } else if(imagefile.isEmpty) {
      file = file;
    }
  }

  // Image Crop Function
  Future<Null> _cropImage() async {
    File ? croppedFile = await ImageCropper.cropImage(
        sourcePath: file!.path,
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
      file = croppedFile;
      setState(() {
        // state = AppState.cropped;
      });
    }
  }


  // Image Save Module
  Future saveImage() async {
    renameImage();
    await GallerySaver.saveImage(file!.path, albumName: "OTWPhotoEditingDemo");
  }

  Future renameImage() async {
    String ogPath = file!.path;
    List<String> ogPathList = ogPath.split('/');
    String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    DateTime today = new DateTime.now();
    String dateSlug = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
    file = await file!.rename("PhotoEditingDemo_$dateSlug.$ogExt");
    print('File : $file');
    print('File Path : ${file!.path}');
  }

}
