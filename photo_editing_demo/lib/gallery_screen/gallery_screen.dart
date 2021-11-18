import 'dart:io';
import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:neon/neon.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}
class _GalleryScreenState extends State<GalleryScreen> {
  final ImagePicker imagePicker = ImagePicker();

  File? imageFile;
  List<Filter> filters = presetFiltersList;
  String? fileName;
  Uint8List? targetlUinit8List;
  Uint8List? originalUnit8List;
  double bright = 0;
  double sat = 1;
  GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

  TextEditingController neonText= TextEditingController();

  double con = 1;
  bool ? isBrightness;
  bool ? isBlur;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => gallery(),
            icon: Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),

      body: imageFile != null
          ? Container(
              child: Column(
                children: [
                  // Expanded(
                  //   flex: 7,
                  //   child: Container(
                  //     //height: Get.height * 0.75,
                  //     width: Get.width,
                  //     child: imageFile != null
                  //         ? Image.file(imageFile!, fit: BoxFit.fill)
                  //         : null,
                  //   ),
                  // ),
                  Stack(
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.matrix(calculateContrastMatrix(con)),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(calculateSaturationMatrix(sat)),
                          child: ExtendedImage(
                            color: bright > 0
                                ? Colors.white.withOpacity(bright)
                                : Colors.black.withOpacity(-bright),
                            colorBlendMode: bright > 0 ? BlendMode.lighten : BlendMode.darken,
                            image: ExtendedFileImageProvider(imageFile!),
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            extendedImageEditorKey: editorKey,
                            mode: ExtendedImageMode.editor,
                            fit: BoxFit.contain,
                            initEditorConfigHandler: (ExtendedImageState ? state) {
                              return EditorConfig(
                                maxScale: 8.0,
                                cropRectPadding: const EdgeInsets.all(20.0),
                                hitTestSize: 20.0,
                              );
                            },
                          ),
                        ),
                      ),
                      
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: blurImage, sigmaY: blurImage ),
                          child: Container(color: Colors.transparent,),
                        ),
                      )
                    ],
                  ),

                  isBlur == true ?
                  Slider(
                    value: blurImage,
                    max: 30,
                    onChanged: (value) => setState(() => blurImage = value),
                  )
                  : Container(),

                  isBrightness == true ? brightness(context) : Container(),
                  Expanded(
                      flex: 1,
                      child: Container(
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
                              onPressed: ()  {
                                setState(() {
                                  isBrightness = true;
                                });
                              },
                              icon: Icon(Icons.brightness_4),
                            ),

                            IconButton(
                              onPressed: ()  {
                                zoomImage();
                              },
                              icon: Icon(Icons.zoom_out),
                            ),

                            IconButton(
                              onPressed: ()  {
                                setState(() {
                                  isBlur = true;
                                });
                              },
                              icon: Icon(Icons.blur_on),
                            ),
                          ],
                        ),
                      )),
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

  zoomImage(){
    return PhotoView(
      imageProvider: AssetImage('$imageFile'),
    );
  }

  brightness(context){
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
              Spacer(flex: 1),
              _buildSat(context),
              Spacer(flex: 1),
              _buildBrightness(context),
              Spacer(flex: 1),
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
  void gallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    imageFile = image != null ? File(image.path) : null;
    if (imageFile != null) {
      setState(() {
        // state = AppState.picked;
      });
    }
  }

  // Crop The Image Portion
  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
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
      imageFile = croppedFile;
      setState(() {
        // state = AppState.cropped;
      });
    }
  }

  // Filter The Image Portion
  Future filterImage(context) async {
    fileName = basename(imageFile!.path);
    var image = imageLib.decodeImage(imageFile!.readAsBytesSync());
    image = imageLib.copyResize(image!, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Photo Filter Example"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName!,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile.isNotEmpty && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
      });
      print(imageFile!.path);
    }
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
