import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editing_demo/collage_screen/collage_screen.dart';
import 'package:photo_editing_demo/collage_screen/collage_screen_controller.dart';
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
  File? compressFile;
  final ImagePicker imagePicker = ImagePicker();


  CollageScreenController collageScreenController = Get.put(CollageScreenController());

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
               // Get.to(()=> CameraScreen());
                camera();
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
                //Get.to(()=> GalleryScreen());
                gallery();
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
            GestureDetector(
              onTap: () {
                //Get.to(()=> CollageScreen());
                selectImages();
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
            const SizedBox(height: 15),

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

  // Select Multiple Images From Gallery
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    try{
      if(selectedImages!.isEmpty){
      } else {
        setState(() {
          collageScreenController.imageFileList.clear();
          collageScreenController.imageFileList.addAll(selectedImages);
        });
        Get.to(()=> CollageScreen(collageScreenController: collageScreenController,));
      }
    } catch(e) {
      print('Error : $e');
    }

    print('Images List Length : ${collageScreenController.imageFileList.length}');
  }

  void camera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        file = File(image.path);
        print('Camera File Path : $file');
        print('Camera Image Path : ${image.path}');
        Fluttertoast.showToast(msg: '${image.path}', toastLength: Toast.LENGTH_LONG);
        renameImage();
      });
      Get.to(()=> CameraScreen(file: file!,));
    } else {}
  }

  void gallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    file = image != null ? File(image.path) : null;
    setState(() {
      compressFile = image != null ? File(image.path) : null;
    });
    if(file != null){
      Get.to(()=> GalleryScreen(file: file!,compressFile: compressFile,));
    }

  }

  // Rename Capture Image
  Future renameImage() async {
    String ogPath = file!.path;
    String frontPath = ogPath.split('cache')[0];
    print('frontPath: $frontPath');
    List<String> ogPathList = ogPath.split('/');
    print('ogPathList: $ogPathList');
    String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    print('ogExt: $ogExt');
    DateTime today = new DateTime.now();
    String dateSlug = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
    file = await file!.rename("${frontPath}cache/PhotoEditingDemo_$dateSlug.$ogExt");
    print('File : $file');
    print('File Path : ${file!.path}');
  }

}
