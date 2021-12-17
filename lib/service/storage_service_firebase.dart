import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uydu/service/base/storage_service.dart';

class FirebaseStorageService implements StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadFile(
    String fileName,
    String folderName,
    File file,
  ) async {
    String extension = '.jpg';
    Reference reference =
        _storage.ref().child(folderName).child(fileName + extension);
    UploadTask uploadTask = reference.putFile(file);

    try {
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('FirebaseStorageService / uploadMessageImage : ${e.code}');
      return null;
    }
  }
}
