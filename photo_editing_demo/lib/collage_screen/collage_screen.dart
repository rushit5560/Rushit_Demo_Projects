import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CollageScreen extends StatefulWidget {
  const CollageScreen({Key? key}) : super(key: key);

  @override
  _CollageScreenState createState() => _CollageScreenState();
}
class _CollageScreenState extends State<CollageScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> imageFileList = [];
  int selectedIndex = 0;

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

      body: imageFileList.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    color: Colors.black,
                    child: ImageListModule(
                        imageFileList: imageFileList,
                        selectedIndex: selectedIndex),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey,
                    child: BottomBarModule(
                        imageFileList: imageFileList,
                        selectedIndex: selectedIndex),
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
          imageFileList.clear();
          imageFileList.addAll(selectedImages);
        });
      }
    } catch(e) {
      print('Error : $e');
    }

    print('Images List Length : ${imageFileList.length}');
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
  List<XFile> imageFileList;
  int selectedIndex;
  ImageListModule({required this.imageFileList, required this.selectedIndex});
  @override
  _ImageListModuleState createState() => _ImageListModuleState();
}
class _ImageListModuleState extends State<ImageListModule> {

  @override
  Widget build(BuildContext context) {
    return widget.imageFileList.length == 1
        ? singleImageSelectedModule()
        : widget.imageFileList.length == 2
            ? twoImageSelectedModule(widget.selectedIndex)
            : Container();
  }

  Widget singleImageSelectedModule() {
    return Container(
      child: Image.file(File('${widget.imageFileList[0].path}')),
    );
  }

  // When Selected Two Images That Time Layouts
  Widget twoImageSelectedModule(int selectedIndex) {
    // return selectedIndex == 0
    //     ? Container(
    //         child: Row(
    //           children: [
    //             Expanded(
    //               child: Container(
    //                 child: Image.file(File('${widget.imageFileList[0].path}')),
    //               ),
    //             ),
    //             Expanded(
    //               child: Container(
    //                 child: Image.file(File('${widget.imageFileList[1].path}')),
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     : selectedIndex == 1
    //         ? Container(
    //             child: Column(
    //               children: [
    //                 Expanded(
    //                   child: Container(
    //                     child:
    //                         Image.file(File('${widget.imageFileList[0].path}')),
    //                   ),
    //                 ),
    //                 Expanded(
    //                   child: Container(
    //                     child:
    //                         Image.file(File('${widget.imageFileList[1].path}')),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           )
    //         : Container(
    //             child: Row(
    //               children: [
    //                 Expanded(
    //                   child: Container(
    //                     child:
    //                         Image.file(File('${widget.imageFileList[0].path}')),
    //                   ),
    //                 ),
    //                 Expanded(
    //                   child: Container(
    //                     child:
    //                         Image.file(File('${widget.imageFileList[1].path}')),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Image.file(File('${widget.imageFileList[0].path}')),
            ),
          ),
          Expanded(
            child: Container(
              child: Image.file(File('${widget.imageFileList[1].path}')),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBarModule extends StatefulWidget {
  List<XFile> imageFileList;
  int selectedIndex;
  BottomBarModule({required this.imageFileList, required this.selectedIndex});

  @override
  _BottomBarModuleState createState() => _BottomBarModuleState();
}
class _BottomBarModuleState extends State<BottomBarModule> {
  @override
  Widget build(BuildContext context) {
    return widget.imageFileList.length == 2 ? twoImageSelectCollageModule(widget.selectedIndex) : Container();
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






// -----> Selected Images Set in GridView
// Widget imageListModule() {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: GridView.builder(
//       itemCount: _imageFileList!.length,
//       shrinkWrap: true,
//       physics: BouncingScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 15,
//         mainAxisSpacing: 15,
//       ),
//       itemBuilder: (context, index){
//         return Image.file(File(_imageFileList![index].path), fit: BoxFit.cover);
//       },
//     ),
//   );
// }