import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImage(String? filePath, childRef) async {
  final _storage = FirebaseStorage.instance;

  if (filePath == null || filePath.length < 1) {
    return '';
  }

  if (!filePath.contains('/storage')) {
    return filePath;
  }

  try {
    File image = File(filePath);
    TaskSnapshot snapshot = await _storage.ref().child(childRef).putFile(image);
    String fileUrl = await snapshot.ref.getDownloadURL();
    return fileUrl;
  } on FirebaseException catch (e) {
    print('Upload image error: $e');
  }
}
