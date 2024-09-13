import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {

  Future<File?> pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }
  
}
