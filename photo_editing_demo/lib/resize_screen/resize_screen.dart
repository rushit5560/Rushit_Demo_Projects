//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;

class ResizeScreen extends StatefulWidget {
 // const ResizeScreen({Key? key}) : super(key: key);

  imageLib.Image resize;
  ResizeScreen({required this.resize});

  @override
  _ResizeScreenState createState() => _ResizeScreenState();
}

class _ResizeScreenState extends State<ResizeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resize Image"),
      ),
      body: Column(
        children: [
          // Image.asset("${widget.resize.data}"),
          //Image.file('${}'),
          // Image(
          //   image: AssetImage('${widget.resize}'),
          // ),

        ],
      ),
    );
  }
}
