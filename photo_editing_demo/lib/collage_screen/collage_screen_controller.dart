import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CollageScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt selectedIndex = 0.obs;
  RxDouble borderRadiusValue = 0.0.obs;
  RxList<XFile> imageFileList = <XFile>[].obs;
}