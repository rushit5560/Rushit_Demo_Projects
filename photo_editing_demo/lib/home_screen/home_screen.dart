import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editing_demo/collage_screen/collage_screen.dart';
import 'package:photo_editing_demo/gallery_screen/gallery_screen.dart';
import 'package:photo_editing_demo/video_screen/video_screen.dart';
import 'package:photo_editing_demo/zz_extra_screen/extra_screen.dart';
import '../camera_screen/camera_screen.dart';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {

  File? file;
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Editing'),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Camera Button
            GestureDetector(
              onTap: () {
                Get.to(()=> CameraScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Gallery Button
            GestureDetector(
              onTap: () {
                Get.to(()=> GalleryScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Collage Button
            /*GestureDetector(
              onTap: () {
                Get.to(()=> CollageScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Text(
                    'Collage',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),*/

            // Video
            GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.video,
                  allowCompression: false,
                );
                if (result != null) {
                  File file = File(result.files.single.path!);
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) {
                  //     return VideoScreen(file: file);
                  //   }),
                  // );
                  Get.to(()=> VideoScreen(file: file));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Text(
                    'Trim Videos',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

}
