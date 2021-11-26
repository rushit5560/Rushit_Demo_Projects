import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'collage_screen_controller.dart';

class CollageScreen extends StatefulWidget {
  //const CollageScreen({Key? key}) : super(key: key);
  //final Function(GlobalKey key) ?  builder;
  CollageScreenController collageScreenController;
  CollageScreen({required this.collageScreenController});
  @override
  _CollageScreenState createState() => _CollageScreenState();
}
class _CollageScreenState extends State<CollageScreen> {


  final GlobalKey key =  GlobalKey();
  // List<XFile> imageFileList = [];
  // int selectedIndex = 0;
  Uint8List ? byte1;
  File ? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collage'),
        centerTitle: true,
        actions: [
          // IconButton(onPressed: () => selectImages(),
          //   icon: Icon(Icons.camera_alt_rounded),
          //
          // ),


          IconButton(
            onPressed: ()async {
              await _capturePng();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),

      body: widget.collageScreenController.imageFileList.isNotEmpty
          ? Column(
              children: [
                //widget.builder!(key),
                Expanded(
                  flex: 9,
                  child: RepaintBoundary(
                    key: key,
                    child: Container(
                      color: Colors.black,
                      child: ImageListModule(
                          // imageFileList: collageScreenController.imageFileList,
                          // selectedIndex: collageScreenController.selectedIndex.value,
                      ),
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


  Future _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      print(boundary);
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      print("image:===$image");
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData ? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      print("byte data:===$byteData");
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/photo.png');
      await imgFile.writeAsBytes(pngBytes);
      setState(() {
        file=imgFile;
      });
      print("File path====:${file!.path}");
      //collageScreenController.imageFileList = pngBytes;
      //bs64 = base64Encode(pngBytes);
      print("png Bytes:====$pngBytes");
      //print("bs64:====$bs64");
      //setState(() {});
      await saveImage();
    } catch (e) {
      print(e);
    }
  }

    Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage("${file!.path}", albumName: "OTWPhotoEditingDemo");
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
            : widget.collageScreenController.imageFileList.length == 3
            ? threeImageSelectedModule(widget.collageScreenController.selectedIndex.value):
            Container(),
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

  Widget threeImageSelectedModule(int selectedIndex) {
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
            Expanded(
              child: Container(
                child: Image.file(File('${widget.collageScreenController.imageFileList[2].path}')),
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
            Expanded(
              child: Container(
                child:
                Image.file(File('${widget.collageScreenController.imageFileList[2].path}')),
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
            Expanded(
              child: Container(
                child:
                Image.file(File('${widget.collageScreenController.imageFileList[2].path}')),
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
    return widget.collageScreenController.imageFileList.length == 2 ?
    twoImageSelectCollageModule(widget.collageScreenController.selectedIndex.value) :
    widget.collageScreenController.imageFileList.length == 3 ?
    threeImageSelectCollageModule(widget.collageScreenController.selectedIndex.value): Container();
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

  Widget threeImageSelectCollageModule(selectedIndex) {
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