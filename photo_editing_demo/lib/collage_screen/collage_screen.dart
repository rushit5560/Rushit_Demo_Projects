import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'collage_screen_controller.dart';

class CollageScreen extends StatefulWidget {
  @override
  _CollageScreenState createState() => _CollageScreenState();
}
class _CollageScreenState extends State<CollageScreen> with SingleTickerProviderStateMixin {

  CollageScreenController collageScreenController = Get.find<CollageScreenController>();

  final GlobalKey key =  GlobalKey();
  Uint8List ? byte1;
  File ? file;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collage'),
        centerTitle: true,
        actions: [

          IconButton(
            onPressed: ()async {
              await _capturePng();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),

      body: collageScreenController.imageFileList.isNotEmpty
          ? Column(
              children: [
                //widget.builder!(key),
                Expanded(
                  flex: 7,
                  child: RepaintBoundary(
                    key: key,
                    child: Container(
                      color: Colors.black,
                      child: Obx(() => collageScreenController.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : ImageListModule(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TabBar(
                            isScrollable: true,
                            indicatorColor: Colors.blue,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelColor: Colors.black,
                            labelPadding: EdgeInsets.only(top: 10.0, bottom: 5, left: 10, right: 10),
                            unselectedLabelColor: Colors.black,
                            controller:  _tabController,
                            labelStyle: TextStyle(fontSize: 17),
                            tabs: [
                              Container(
                                child: Tab(text: "Layout"),
                              ),
                              Container(
                                child: Tab(text: "Border Width"),
                              ),
                              Container(
                                child: Tab(text: "Border Color"),
                              ),
                              Container(
                                child: Tab(text: "Border Radius"),
                              ),
                              Container(
                                child: Tab(text: "Image Spacing"),
                              ),

                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Container(
                            height: Get.height * 0.45,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                BottomBarModule(),
                                Text("B"),
                                Text("C"),
                                BorderRadiusModule(),
                                Text("E"),
                              ],
                            ),
                          ),
                        )
                      ],
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
    await GallerySaver.saveImage("${file!.path}",
        albumName: "OTWPhotoEditingDemo");
  }

  // No Image Selected Text Module
  Widget emptyListModule() {
    return Container(
      child: Center(child: Text('No Image Selected', textScaleFactor: 1.3)),
    );
  }

}

class BorderRadiusModule extends StatelessWidget {
  const BorderRadiusModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


// Selected Images Layout
class ImageListModule extends StatefulWidget {
  @override
  _ImageListModuleState createState() => _ImageListModuleState();
}
class _ImageListModuleState extends State<ImageListModule> {
  CollageScreenController collageScreenController = Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    print("Image index===${collageScreenController.selectedIndex.value}");
    return Obx(
        () => collageScreenController.imageFileList.length == 1
            ? singleImageSelectedModule()
            : collageScreenController.imageFileList.length == 2
            ? twoImageSelectedModule(collageScreenController.selectedIndex.value)
            : collageScreenController.imageFileList.length == 3
            ? threeImageSelectedModule(collageScreenController.selectedIndex.value):
            Container(),
    );
  }

  Widget singleImageSelectedModule() {
    return Container(
      child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(collageScreenController.borderRadiusValue.value),
                  ),
                  child: Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
              Expanded(
                child: Container(
                  child: Image.file(File('${collageScreenController.imageFileList[1].path}')),
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
                  Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
              Expanded(
                child: Container(
                  child:
                  Image.file(File('${collageScreenController.imageFileList[1].path}')),
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
                  Image.file(File('${collageScreenController.imageFileList[0].path}')),
                ),
              ),
              Expanded(
                child: Container(
                  child:
                  Image.file(File('${collageScreenController.imageFileList[1].path}')),
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget threeImageSelectedModule(int selectedIndex) {
    return Obx(
      () => selectedIndex == 0
          ? Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Image.file(File(
                          '${collageScreenController.imageFileList[0].path}')),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Image.file(File(
                          '${collageScreenController.imageFileList[1].path}')),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Image.file(File(
                          '${collageScreenController.imageFileList[2].path}')),
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
                          child: Image.file(File(
                              '${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Image.file(File(
                              '${collageScreenController.imageFileList[1].path}')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Image.file(File(
                              '${collageScreenController.imageFileList[2].path}')),
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
                          child: Image.file(File(
                              '${collageScreenController.imageFileList[0].path}')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Image.file(File(
                              '${collageScreenController.imageFileList[1].path}')),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Image.file(File(
                              '${collageScreenController.imageFileList[2].path}')),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class BottomBarModule extends StatefulWidget {
  @override
  _BottomBarModuleState createState() => _BottomBarModuleState();
}
class _BottomBarModuleState extends State<BottomBarModule> {
  CollageScreenController collageScreenController = Get.find<CollageScreenController>();

  @override
  Widget build(BuildContext context) {
    return collageScreenController.imageFileList.length == 2
        ? twoImageSelectCollageModule()
        : collageScreenController.imageFileList.length == 3
            ? threeImageSelectCollageModule()
            : Container();
  }

  Widget twoImageSelectCollageModule() {
    return ListView.builder(
      itemCount: 3,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                collageScreenController.selectedIndex.value = index;
                print(
                    'selectedIndex : ${collageScreenController.selectedIndex.value}');
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

  Widget threeImageSelectCollageModule() {
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
                collageScreenController.selectedIndex.value = index;
                print('selectedIndex : ${collageScreenController.selectedIndex.value}');
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              child: Text(
                '2.$index',
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}