import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as imageLib;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Camera'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => camera(),
          icon: Icon(Icons.camera_alt_rounded),
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
                      // height:Get.height,
                      width: Get.width,
                      child: file != null
                          ? Image.file(file!, fit: BoxFit.fill)
                          : null,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () async {
                        await getImage(context);
                      },
                      icon: Icon(Icons.filter_alt_rounded),
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
    final image = await imagePicker.getImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    } else {}
  }

  List<Filter> filters = presetFiltersList;
  String ? fileName;

  Future getImage(context) async {
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
        ),
      ),
    );
    if (imagefile.isNotEmpty && imagefile.containsKey('image_filtered')) {
      setState(() {
        file = imagefile['image_filtered'];
      });
      print(file!.path);
    }
  }

  @override
  void dispose() {
    file!.delete();
    super.dispose();
  }

 // Future filterImage() async {
 //   print('FILE PATH : ${file!.path}');
 //    imagefile = await imagePicker.getImage(source: ImageSource.camera);
 //   fileName = file!.path;
 //   // var image = imageLib.decodeImage(imagefile!.readAsBytesSync());
 //   // var image = imageLib.copyResize(image!, width: 600);
 //   Map imageFile = await Navigator.push(
 //     context,
 //       MaterialPageRoute(
 //           builder: (context) => PhotoFilterSelector(
 //             filename: fileName!,
 //             filters: filters,
 //             image: imagefile!,
 //             title: Text("Photo Filter"),
 //             loader: Center(child: CircularProgressIndicator()),
 //             fit: BoxFit.contain,
 //           ),
 //       ),
 //   );
 //
 //   if (imageFile.isNotEmpty && imageFile.containsKey('image_filtered')) {
 //     setState(() {
 //       imagefile = imageFile['image_filtered'];
 //     });
 //     print("File Path : ${imagefile!.path}");
 //   }
 //
 // }
}
