import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'collage_screen_controller.dart';

class CollageScreen extends StatefulWidget {
  const CollageScreen({Key? key}) : super(key: key);

  @override
  _CollageScreenState createState() => _CollageScreenState();
}
class _CollageScreenState extends State<CollageScreen> {
  CollageScreenController collageScreenController = Get.put(CollageScreenController());
  final ImagePicker _picker = ImagePicker();
  // List<XFile> imageFileList = [];
  // int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collage'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => selectImages(),
            icon: Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),

      body: collageScreenController.imageFileList.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    color: Colors.black,
                    child: ImageListModule(
                        // imageFileList: collageScreenController.imageFileList,
                        // selectedIndex: collageScreenController.selectedIndex.value,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey,
                    child: BottomBarModule(
                        // imageFileList: collageScreenController.imageFileList,
                        // selectedIndex: collageScreenController.selectedIndex.value,
                    ),
                  ),
                ),
              ],
            )
          : emptyListModule(),
    );
  }

  // Select Multiple Images From Gallery
  void selectImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    try{
      if(selectedImages!.isEmpty){
      } else {
        setState(() {
          collageScreenController.imageFileList.clear();
          collageScreenController.imageFileList.addAll(selectedImages);
        });
      }
    } catch(e) {
      print('Error : $e');
    }

    print('Images List Length : ${collageScreenController.imageFileList.length}');
  }

  // No Image Selected Text Module
  Widget emptyListModule() {
    return Container(
      child: Center(child: Text('No Image Selected', textScaleFactor: 1.3)),
    );
  }

}

// Selected Images Layout
class ImageListModule extends StatefulWidget {
  CollageScreenController collageScreenController = Get.find();
  // List<XFile> imageFileList;
  // int selectedIndex;
  // ImageListModule({required this.imageFileList/*, required this.selectedIndex*/});
  @override
  _ImageListModuleState createState() => _ImageListModuleState();
}
class _ImageListModuleState extends State<ImageListModule> {

  @override
  Widget build(BuildContext context) {
    return Obx(
        () => widget.collageScreenController.imageFileList.length == 1
            ? singleImageSelectedModule()
            : widget.collageScreenController.imageFileList.length == 2
            ? twoImageSelectedModule(widget.collageScreenController.selectedIndex.value)
            : Container(),
    );
  }

  Widget singleImageSelectedModule() {
    return Container(
      child: Image.file(File('${widget.collageScreenController.imageFileList[0].path}')),
    );
  }

  // When Selected Two Images That Time Layouts
  Widget twoImageSelectedModule(int selectedIndex) {
    return Obx(
        ()=> selectedIndex == 0
            ? Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Image.file(File('${widget.collageScreenController.imageFileList[0].path}')),
                ),
              ),
              Expanded(
                child: Container(
                  child: Image.file(File('${widget.collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ],
          ),
        )
            : selectedIndex == 1
            ? Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child:
                  Image.file(File('${widget.collageScreenController.imageFileList[0].path}')),
                ),
              ),
              Expanded(
                child: Container(
                  child:
                  Image.file(File('${widget.collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ],
          ),
        )
            : Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child:
                  Image.file(File('${widget.collageScreenController.imageFileList[0].path}')),
                ),
              ),
              Expanded(
                child: Container(
                  child:
                  Image.file(File('${widget.collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class BottomBarModule extends StatefulWidget {
  CollageScreenController collageScreenController = Get.find();
  // List<XFile> imageFileList;
  // int selectedIndex;
  // BottomBarModule({required this.imageFileList/*, required this.selectedIndex*/});

  @override
  _BottomBarModuleState createState() => _BottomBarModuleState();
}
class _BottomBarModuleState extends State<BottomBarModule> {
  @override
  Widget build(BuildContext context) {
    return widget.collageScreenController.imageFileList.length == 2 ? twoImageSelectCollageModule(widget.collageScreenController.selectedIndex.value) : Container();
  }


  Widget twoImageSelectCollageModule(selectedIndex) {
    return ListView.builder(
      itemCount: 3,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                print('selectedIndex : $selectedIndex');
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Text(
                '2.$index',
                textScaleFactor: 1.2,
              ),
            ),
          ),
        );
      },
    );
  }
}