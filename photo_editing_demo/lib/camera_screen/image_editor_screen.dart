import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';

class ImageEditorScreen extends StatefulWidget {
  File file = Get.arguments;

  @override
  _ImageEditorScreenState createState() => _ImageEditorScreenState();
}
class _ImageEditorScreenState extends State<ImageEditorScreen> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: Text('Image Editor'), centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async => await renameAndSaveImage(),
            icon: Icon(Icons.save),
          ),
        ],
      ),

      body: ImagePainter.file(
        widget.file,
        key: _imageKey,
        scalable: true,
        initialStrokeWidth: 2,
        initialColor: Colors.green,
        initialPaintMode: PaintMode.freeStyle,
      ),
    );
  }

  // Rename & Save Capture Image
  Future renameAndSaveImage() async {
    // var image = await _imageKey.currentState!.exportImage().toString();
    // String ogPath = _imageKey.currentState!.exportImage().toString();
    // String frontPath = ogPath.split('cache')[0];
    // print('frontPath: $frontPath');
    // List<String> ogPathList = ogPath.split('/');
    // print('ogPathList: $ogPathList');
    // String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    // print('ogExt: $ogExt');
    // DateTime today = new DateTime.now();
    // String dateSlug = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
    // widget.file = await widget.file.rename("${frontPath}cache/PhotoEditingDemo_$dateSlug.$ogExt");
    // print('File : ${widget.file}');
    // print('File Path : ${widget.file.path}');
    final image = await _imageKey.currentState!.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath = '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imgFile = File('$fullPath');
    imgFile.writeAsBytesSync(image!);
    await GallerySaver.saveImage(imgFile.path, albumName: "OTWPhotoEditingDemo");
  }
}
