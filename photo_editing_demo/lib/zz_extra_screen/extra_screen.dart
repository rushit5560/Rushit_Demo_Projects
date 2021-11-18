import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_editor/image_editor.dart' as imgEditor;
import 'package:image_picker/image_picker.dart';

class ExtraScreen extends StatefulWidget {
  // const ExtraScreen({Key? key}) : super(key: key);
  @override
  _ExtraScreenState createState() => _ExtraScreenState();
}
class _ExtraScreenState extends State<ExtraScreen> {
  File? file;
  final ImagePicker imagePicker = ImagePicker();

  final textOption = imgEditor.AddTextOption();
  TextEditingController addTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Extra Screen'),
          centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => camera(),
            icon: Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),

      body: /*file != null ?*/
      Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: Colors.black,
                      width: Get.width,
                      child: file != null
                          ? Image.file(file!)
                          : null,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                   child: TextButton(
                     onPressed: () {
                       // openAlertDialogBox();
                      },
                     child: Text('Add Text Button'),
                   ),
                  ),
                ],
              ),
            ),
          // : Container(
          //     child: Center(
          //       child: Text('No Image Selected', textScaleFactor: 1.3),
          //     ),
          //   ),
    );
  }

  // Image From Camera
  void camera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    } else {}
  }

  _shareImage() async {
    try{

    } catch(e) {
      print('Share Error : $e');
    }
  }

  // Open Alert Dialog
  // openAlertDialogBox() async {
  //   return showDialog(
  //       context: context,
  //       builder: (context){
  //     return AlertDialog(
  //       content: TextFormField(
  //         controller: addTextController,
  //         decoration: InputDecoration(
  //           isDense: true,
  //           contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(color: Colors.grey),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(color: Colors.grey),
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //               onPressed: () {
  //                 print('AAAAA');
  //                 textOptions();
  //               },
  //               child: Text('Submit'),
  //             ),
  //           ],
  //     );
  //   });
  // }

  // Add Text options
  // void textOptions() {
  //   textOption.addText(
  //     imgEditor.EditorText(
  //       offset: Offset(10, 10),
  //       text: addTextController.text,
  //       fontSizePx: 20,
  //       textColor: Colors.red,
  //     ),
  //   );
  // }


}
