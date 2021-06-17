import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

pickImage(onImageChange) async {
  PickedFile? _pickedImage;
  final _picker = ImagePicker();
  await Permission.photos.request();

  PermissionStatus permissionStatus = await Permission.photos.status;

  if (permissionStatus.isGranted) {
    _pickedImage =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 10);

    if (_pickedImage != null) {
      onImageChange(_pickedImage.path);
    } else {
      print('No image');
    }
  } else {
    print('Permission is not granted');
  }
}
