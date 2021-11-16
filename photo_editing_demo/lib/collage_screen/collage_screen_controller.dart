import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CollageScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxList<XFile> imageFileList = <XFile>[].obs;
}