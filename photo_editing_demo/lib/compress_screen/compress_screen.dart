import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompressScreen extends StatefulWidget {
  File imageFile;
  File compressFile;
  CompressScreen({required this.imageFile, required this.compressFile});

  //const CompressScreen({Key? key}) : super(key: key);

  @override
  _CompressScreenState createState() => _CompressScreenState();
}

class _CompressScreenState extends State<CompressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Compress Image"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Original File", style: TextStyle(color: Colors.black, fontSize: 18),),

                Text("Compressed File",style: TextStyle(color: Colors.black, fontSize: 18))
              ],
            ),
            SizedBox(height: 10,),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Image.file(widget.imageFile)),
                SizedBox(width: 5,),
                Expanded(child: Image.file(widget.compressFile)),
              ],
            ),

            SizedBox(height: 10,),

            Text("Original file size: ${widget.imageFile.lengthSync()} kb",
                style: TextStyle(color: Colors.black, fontSize: 17)),

            SizedBox(height: 5,),
            Text("Compress file size: ${widget.compressFile.lengthSync()} kb",
                style: TextStyle(color: Colors.black, fontSize: 17)),
          ],
        ),
      ),
    );
  }
}
