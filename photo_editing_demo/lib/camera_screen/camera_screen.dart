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
import 'package:share/share.dart';
import 'image_editor_screen.dart';


class CameraScreen extends StatefulWidget {
  File file;
  CameraScreen({required this.file});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}
class _CameraScreenState extends State<CameraScreen> {
  //File? file;
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
            onPressed: () async => await saveImage(),
            icon: Icon(Icons.save),
          ),
          IconButton(
            onPressed: () async => await shareImage(),
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: widget.file.toString().isNotEmpty
          ? Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: Container(
                      color: Colors.black,
                      width: Get.width,
                      child:  widget.file.toString().isNotEmpty
                          ? Image.file(widget.file)
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
                        IconButton(
                          onPressed: () {
                            Get.to(()=> ImageEditorScreen(), arguments: widget.file);
                          },
                          icon: Icon(Icons.create),
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


  // Add Filter in Image
  Future filterImage(context) async {
    fileName = basename(widget.file.path);
    var image = imageLib.decodeImage(widget.file.readAsBytesSync());
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
        widget.file = imagefile['image_filtered'];
      });
      print(widget.file.path);
    } /*else if(imagefile.isEmpty) {
      file = file;
    }*/
    renameImage();
  }

  // Image Crop Function
  Future<Null> _cropImage() async {
    File ? croppedFile = await ImageCropper.cropImage(
        sourcePath: widget.file.path,
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
      widget.file = croppedFile;
      setState(() {
        // state = AppState.cropped;
      });
    }
    renameImage();
  }

  // Share The
  shareImage() async {
    try{
      // final ByteData bytes = await rootBundle.load('${file!.path}');
      await Share.shareFiles(['${widget.file.path}']);
    } catch(e) {
      print('Share Error : $e');
    }
  }


  // Image Save Module
  Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage(widget.file.path, albumName: "OTWPhotoEditingDemo");
  }

  // Rename Capture Image
  Future renameImage() async {
    String ogPath = widget.file.path;
    String frontPath = ogPath.split('cache')[0];
    print('frontPath: $frontPath');
    List<String> ogPathList = ogPath.split('/');
    print('ogPathList: $ogPathList');
    String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    print('ogExt: $ogExt');
    DateTime today = new DateTime.now();
    String dateSlug = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
    widget.file = await widget.file.rename("${frontPath}cache/PhotoEditingDemo_$dateSlug.$ogExt");
    print('File : ${widget.file}');
    print('File Path : ${widget.file.path}');
  }

}
