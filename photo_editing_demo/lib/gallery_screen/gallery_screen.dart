import 'dart:io';
import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editing_demo/compress_screen/compress_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

class GalleryScreen extends StatefulWidget {
  File file;
  File? compressFile;
  GalleryScreen({required this.file, required this.compressFile});
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImagePicker imagePicker = ImagePicker();
  int? i;
  //File? imageFile;

  imageLib.Image ? resize;
  List<Filter> filters = presetFiltersList;
  String? fileName;
  Uint8List? targetlUinit8List;
  Uint8List? originalUnit8List;
  double bright = 0;
  double sat = 1;
  ImageProvider? provider;
  GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

  TextEditingController neonText = TextEditingController();

  double con = 1;
  bool isBrightness = false;
  bool isBlur = false;
  bool isCompress = false;
  final defaultColorMatrix = const <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];

  List<double> calculateContrastMatrix(double contrast) {
    final m = List<double>.from(defaultColorMatrix);
    m[0] = contrast;
    m[6] = contrast;
    m[12] = contrast;
    return m;
  }

  double blurImage = 0;
  List<Icon> iconList = [
    Icon(Icons.crop),
    Icon(Icons.filter_alt_rounded),
    Icon(Icons.brightness_4),
    //Icon(Icons.zoom_out),
    Icon(Icons.blur_on),
    Icon(Icons.compress_outlined),
    Icon(Icons.photo_size_select_actual),
  ];
  //File ? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await saveImage();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: widget.file.toString().isNotEmpty
          ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 9,
                    child: Stack(
                      children: [
                        ColorFiltered(
                          colorFilter:
                              ColorFilter.matrix(calculateContrastMatrix(con)),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.matrix(
                                calculateSaturationMatrix(sat)),
                            child: ExtendedImage(
                              color: bright > 0
                                  ? Colors.white.withOpacity(bright)
                                  : Colors.black.withOpacity(-bright),
                              colorBlendMode: bright > 0
                                  ? BlendMode.lighten
                                  : BlendMode.darken,
                              image: ExtendedFileImageProvider(widget.file),
                              extendedImageEditorKey: editorKey,
                              mode: ExtendedImageMode.editor,
                              fit: BoxFit.contain,
                              initEditorConfigHandler:
                                  (ExtendedImageState? state) {
                                return EditorConfig(
                                  maxScale: 8.0,
                                  //cropRectPadding: const EdgeInsets.all(20.0),
                                  hitTestSize: 20.0,
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: blurImage, sigmaY: blurImage),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  indexFunction(context),

                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: iconList.length,
                        itemBuilder: (context, index){

                          return GestureDetector(
                            onTap: (){
                              i = index;

                              if(i == 0){
                                _cropImage();
                              } else if(i == 1){
                                filterImage(context);
                              } else if(i == 2){
                                setState(() {
                                  i = 2;
                                });
                              } /*else if(i == 3){
                                print("====");
                                zoomImage();
                              }*/ else if(i == 3){
                                print(index);
                                setState(() {
                                  i = 3;
                                });
                              } else if(i ==4){
                                compressImage(widget.file).then((value) {
                                  Get.to(() => CompressScreen(
                                    imageFile: widget.file,
                                    compressFile: widget.compressFile!,
                                  ))!
                                      .then((value) {
                                    // setState(() {});
                                  });
                                });
                              } else if(i == 5){
                                resizeImage(widget.file).then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Original length: ${imageTemp!.length}\n"
                                          "Resize length: ${resize!.length}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  /*Get.to(() => ResizeScreen(
                                resize: resize!
                              ))!.then((value) {
                                Fluttertoast.showToast(
                                    msg: "Resize length: ${resize!.length}",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              });*/
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                               child: iconList[index],
                            ),
                          );
                        }),
                  ),

                  /*Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              _cropImage();
                            },
                            icon: Icon(
                              Icons.crop,
                              color: Colors.black,
                              size: 30,
                            )),
                        IconButton(
                          onPressed: () async {
                            await filterImage(context);
                          },
                          icon: Icon(Icons.filter_alt_rounded),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              //isBrightness = true;
                              index = 1;
                            });
                          },
                          icon: Icon(Icons.brightness_4),
                        ),
                        IconButton(
                          onPressed: () {
                            zoomImage();
                          },
                          icon: Icon(Icons.zoom_out),
                        ),
                        IconButton(
                          onPressed: () {
                            Slider(
                              value: blurImage,
                              max: 30,
                              onChanged: (value) => setState(() => blurImage = value),
                            );
                            *//*setState(() {
                              //index = 1;
                              index = 0;
                              //print(isBlur);
                            });*//*
                          },
                          icon: Icon(Icons.blur_on),
                        ),
                        IconButton(
                          onPressed: () async {

                            compressImage(imageFile!).then((value) {
                              Get.to(() => CompressScreen(
                                        imageFile: imageFile!,
                                        compressFile: compressFile!,
                                      ))!
                                  .then((value) {
                                // setState(() {});
                              });
                            });
                          },
                          icon: Icon(Icons.compress_outlined),
                        ),

                        IconButton(
                          onPressed: () async {
                            resizeImage(imageFile!).then((value) {
                              Fluttertoast.showToast(
                                  msg: "Original length: ${imageTemp!.length}\n"
                                      "Resize length: ${resize!.length}",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                              Get.to(() => ResizeScreen(
                                resize: resize!
                              ))!.then((value) {
                                Fluttertoast.showToast(
                                    msg: "Resize length: ${resize!.length}",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              });
                            });
                          },
                          icon: Icon(Icons.photo_size_select_actual),
                        ),

                        IconButton(
                          onPressed: () async {
                            Get.to(() => NeonText());
                          },
                          icon: Icon(Icons.text_fields),
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            )
          : Container(
              child: Center(
                child: Text('No Image Selected', textScaleFactor: 1.3),
              ),
            ),
    );
  }

  indexFunction(context) {
    print("index===$i");
    return Container(
      child: i == 3
          ? Slider(
              value: blurImage,
              max: 30,
              onChanged: (value) => setState(() {
                blurImage = value;
                //imageFile=File("$blurImage");
              }),
            )
          : i == 2
              ? brightness(context)
              : Container(),
    );
  }
  imageLib.Image? imageTemp;
  Future resizeImage(File file)async{
    imageTemp = imageLib.decodeImage(file.readAsBytesSync());
    imageLib.Image resized_img = imageLib.copyResize(imageTemp!,height: 800);
    resize= resized_img;
    print(resized_img.length);
    print(imageTemp!.length);
  }

  Future compressImage(File file) async {
    print("file: $file");
    final filePath = file.absolute.path;
    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 5,
    );
    print("Original path : ${file.lengthSync()}");
    print(file.absolute.path);
    print("Compress path : ${result!.lengthSync()}");
    setState(() {
      widget.compressFile = result;
    });
    setState(() {});
    print("compressFile: ${widget.compressFile!.lengthSync()}");
    // setState(() {
    //
    // });
    /*final logger = TimeLogger();
    logger.startRecoder();
    print("start compress webp");
    final quality = 90;
    final tmpDir = (await getTemporaryDirectory()).path;
    final target =
        "$tmpDir/${DateTime.now().millisecondsSinceEpoch}-$quality.webp";
    final srcPath = await getExampleFilePath();
    final result = await FlutterImageCompress.compressAndGetFile(
      srcPath,
      target,
      format: CompressFormat.webp,
      minHeight: 800,
      minWidth: 800,
      quality: quality,
    );

    if (result == null) return;

    print("Compress webp success.");
    logger.logTime();
    print("src, path = $srcPath length = ${File(srcPath).lengthSync()}");
    print(
        "Compress webp result path: ${result.absolute.path}, size: ${result.lengthSync()}");

    provider = FileImage(result);
    setState(() {});*/
  }

  /*Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }
  Future<String> getExampleFilePath() async {
    final img = AssetImage("assets/images/heart.png");
    print("pre compress");
    final config = new ImageConfiguration();

    AssetBundleImageKey key = await img.obtainKey(config);
    final ByteData data = await key.bundle.load(key.name);
    final dir = await path_provider.getTemporaryDirectory();

    File file = createFile("${dir.absolute.path}/test.png");
    file.createSync(recursive: true);
    file.writeAsBytesSync(data.buffer.asUint8List());
    return file.absolute.path;
  }
  File createFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    return file;
  }*/

  /* compress(){
    return Container(
      child: Column(
        children: [
          Text("Original file size: ${File(srcPath).lengthSync()}");
        ],
      ),
    );
  }*/

  zoomImage() {
    return PhotoView(
      imageProvider: AssetImage("${widget.file}"),
    );
  }

  brightness(context) {
    return Expanded(
      flex: 3,
      child: SliderTheme(
        data: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.never,
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Spacer(),
              _buildSat(context),
              //Spacer(),
              _buildBrightness(context),
              //Spacer(),
              _buildCon(context),
              //Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  List<double> calculateSaturationMatrix(double saturation) {
    final m = List<double>.from(defaultColorMatrix);
    final invSat = 1 - saturation;
    final R = 0.213 * invSat;
    final G = 0.715 * invSat;
    final B = 0.072 * invSat;

    m[0] = R + saturation;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + saturation;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + saturation;

    return m;
  }

  Widget _buildCon(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Column(
          children: <Widget>[
            Icon(
              Icons.color_lens,
              color: Theme.of(context).accentColor,
            ),
            Text(
              "Contrast",
              style: TextStyle(color: Theme.of(context).accentColor),
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: 'con : ${con.toStringAsFixed(2)}',
            onChanged: (double value) {
              setState(() {
                con = value;
              });
            },
            divisions: 50,
            value: con,
            min: 0,
            max: 4,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
          child: Text(con.toStringAsFixed(2)),
        ),
      ],
    );
  }

  Widget _buildSat(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Column(
          children: <Widget>[
            Icon(
              Icons.brush,
              color: Theme.of(context).accentColor,
            ),
            Text(
              "Saturation",
              style: TextStyle(color: Theme.of(context).accentColor),
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: 'sat : ${sat.toStringAsFixed(2)}',
            onChanged: (double value) {
              setState(() {
                sat = value;
              });
            },
            divisions: 50,
            value: sat,
            min: 0,
            max: 2,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
          child: Text(sat.toStringAsFixed(2)),
        ),
      ],
    );
  }

  Widget _buildBrightness(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Column(
          children: <Widget>[
            Icon(
              Icons.brightness_4,
              color: Theme.of(context).accentColor,
            ),
            Text(
              "Brightness",
              style: TextStyle(color: Theme.of(context).accentColor),
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: '${bright.toStringAsFixed(2)}',
            onChanged: (double value) {
              setState(() {
                bright = value;
              });
            },
            divisions: 50,
            value: bright,
            min: -1,
            max: 1,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
          child: Text(bright.toStringAsFixed(2)),
        ),
      ],
    );
  }

  // Getting the image from the Gallery


  // Crop The Image Portion
  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: widget.file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop',
        ));
    if (croppedFile != null) {
      widget.file = croppedFile;
      setState(() {
        // state = AppState.cropped;
      });
    }
  }

  // Filter The Image Portion
  Future filterImage(context) async {
    fileName = basename(widget.file.path);
    var image = imageLib.decodeImage(widget.file.readAsBytesSync());
    image = imageLib.copyResize(image!, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Photo Filter Example"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName!,
          loader: Center(child: CircularProgressIndicator(color: Colors.black,)),
          fit: BoxFit.cover,
          circleShape: false,
          appBarColor: Colors.black,

        ),
      ),
    );
    if (imagefile.isNotEmpty && imagefile.containsKey('image_filtered')) {
      setState(() {
        widget.file = imagefile['image_filtered'];
      });
      print(widget.file.path);
    }
    renameImage();
  }

  // Rename Gallery Image
  Future renameImage() async {
    String ogPath = widget.file.path;
    String frontPath = ogPath.split('cache')[0];
    print('frontPath: $frontPath');
    List<String> ogPathList = ogPath.split('/');
    print('ogPathList: $ogPathList');
    String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    print('ogExt: $ogExt');
    DateTime today = new DateTime.now();
    String dateSlug = "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
    widget.file = await widget.file.rename("${frontPath}cache/PhotoEditingDemo_$dateSlug.$ogExt");
    print('File : ${widget.file}');
    print('File Path : ${widget.file.path}');
  }

  // Image Save Module
  Future saveImage() async {
    // renameImage();
    await GallerySaver.saveImage(widget.file.path,
        albumName: "OTWPhotoEditingDemo");
  }

/*Future _resizeImage() async {
    //imageFile = await imagePicker.getImage(source: ImageSource.gallery);
    // String imageUrl = 'https://picsum.photos/250?image=9';
    //http.Response response = await http.get(imageUrl);
    if (imageFile != null) {
      originalUnit8List = imageFile!.readAsBytesSync();

      ui.Image originalUiImage = await decodeImageFromList(originalUnit8List!);
      ByteData? originalByteData = await originalUiImage.toByteData();
      print(
          'original image ByteData size is ${originalByteData!.lengthInBytes}');

      var codec = await ui.instantiateImageCodec(originalUnit8List!,
          targetHeight: 50, targetWidth: 50);
      var frameInfo = await codec.getNextFrame();
      ui.Image targetUiImage = frameInfo.image;

      ByteData? targetByteData =
          await targetUiImage.toByteData(format: ui.ImageByteFormat.png);
      print('target image ByteData size is ${targetByteData!.lengthInBytes}');
      targetlUinit8List = targetByteData.buffer.asUint8List();

      setState(() {});
    } else {
      Text("No image selected");
    }
  }*/

}

class TimeLogger {
  String tag;

  TimeLogger([this.tag = "", this.start = 0]);

  int start;

  void startRecoder() {
    start = DateTime.now().millisecondsSinceEpoch;
  }

  void logTime() {
    if (start == null) {
      print('The start is null, you must start recoder first.');
      return;
    }
    final diff = DateTime.now().millisecondsSinceEpoch - start;
    if (tag != "") {
      print("$tag : $diff ms");
    } else {
      print("run time $diff ms");
    }
  }
}
