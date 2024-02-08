import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {

  Future getImage() async{

    RxString imagePath = ''.obs;
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null) {
      imagePath.value = image.path.toString();
    }
  }
}