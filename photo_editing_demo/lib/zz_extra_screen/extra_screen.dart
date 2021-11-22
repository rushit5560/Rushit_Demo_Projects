import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';


class ExtraScreen extends StatefulWidget {
  // const ExtraScreen({Key? key}) : super(key: key);
  @override
  _ExtraScreenState createState() => _ExtraScreenState();
}
class _ExtraScreenState extends State<ExtraScreen> {
  final _key = GlobalKey<ScaffoldState>();
  final _imageKey = GlobalKey<ImagePainterState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text("Image Painter Example"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: saveImage,
          )
        ],
      ),
      body: ImagePainter.asset(
        "assets/images/sample.jpg",
        key: _imageKey,
        scalable: false,
        initialStrokeWidth: 2,
        initialColor: Colors.green,
        initialPaintMode: PaintMode.freeStyle,
      ),
    );
  }

  void saveImage() async {
    final image = await _imageKey.currentState!.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath =
        '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
    final imgFile = File('$fullPath');
    imgFile.writeAsBytesSync(image!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[700],
        padding: const EdgeInsets.only(left: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Image Exported successfully.",
                style: TextStyle(color: Colors.white)),
            TextButton(
                onPressed: () {
                  /*OpenFile.open("$fullPath")*/
                },
                child: Text("Open", style: TextStyle(color: Colors.blue[200])))
          ],
        ),
      ),
    );
  }

}

