import 'dart:io';

import 'package:path/path.dart';

import 'dart:typed_data';

//import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImagePicker imagePicker = ImagePicker();

  File? imageFile;
  List<Filter> filters = presetFiltersList;
  String? fileName;
  Uint8List? targetlUinit8List;
  Uint8List? originalUnit8List;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => gallery(),
            icon: Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),

      body: imageFile != null
          ? Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: Container(
                      //height: Get.height * 0.75,
                      width: Get.width,
                      child: imageFile != null
                          ? Image.file(imageFile!, fit: BoxFit.fill)
                          : null,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _cropImage();
                                },
                                icon: Icon(
                                  Icons.crop,
                                  color: Colors.black,
                                  size: 30,
                                )),
                            IconButton(
                              onPressed: () async {
                                await filterImage(context);
                              },
                              icon: Icon(Icons.filter_alt_rounded),
                            ),
                          ],
                        ),
                      )),
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

  // Getting the image from the Gallery
  void gallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    imageFile = image != null ? File(image.path) : null;
    if (imageFile != null) {
      setState(() {
        // state = AppState.picked;
      });
    }
  }

  // Crop The Image Portion
  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
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
        // state = AppState.cropped;
      });
    }
  }

  // Filter The Image Portion
  Future filterImage(context) async {
    fileName = basename(imageFile!.path);
    var image = imageLib.decodeImage(imageFile!.readAsBytesSync());
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
        ),
      ),
    );
    if (imagefile.isNotEmpty && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
      });
      print(imageFile!.path);
    }
  }

/*Future _resizeImage() async {
    //imageFile = await imagePicker.getImage(source: ImageSource.gallery);
    // String imageUrl = 'https://picsum.photos/250?image=9';
    //http.Response response = await http.get(imageUrl);
    if (imageFile != null) {
      originalUnit8List = imageFile!.readAsBytesSync();

      ui.Image originalUiImage = await decodeImageFromList(originalUnit8List!);
      ByteData? originalByteData = await originalUiImage.toByteData();
      print(
          'original image ByteData size is ${originalByteData!.lengthInBytes}');

      var codec = await ui.instantiateImageCodec(originalUnit8List!,
          targetHeight: 50, targetWidth: 50);
      var frameInfo = await codec.getNextFrame();
      ui.Image targetUiImage = frameInfo.image;

      ByteData? targetByteData =
          await targetUiImage.toByteData(format: ui.ImageByteFormat.png);
      print('target image ByteData size is ${targetByteData!.lengthInBytes}');
      targetlUinit8List = targetByteData.buffer.asUint8List();

      setState(() {});
    } else {
      Text("No image selected");
    }
  }*/

}
