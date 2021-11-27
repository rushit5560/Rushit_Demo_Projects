

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CollageScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt selectedIndex = 0.obs;
  //RxInt borderColor = 0.obs;
  RxInt activeColor = 0.obs;
  List<Color> borderColor = [Colors.white, Colors.black, Colors.pink, Colors.green, Colors.grey, Colors.yellow, Colors.orange];
  RxDouble borderRadiusValue = 0.0.obs;
  RxDouble borderWidthValue = 0.0.obs;
  //RxDouble _value = 0.0.obs;
  RxList<XFile> imageFileList = <XFile>[].obs;
}