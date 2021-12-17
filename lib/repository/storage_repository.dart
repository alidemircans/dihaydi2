import 'dart:io';

import 'package:uydu/base/storage_base.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/service/storage_service_firebase.dart';


class StorageRepository implements StorageBase {
  FirebaseStorageService _service = locator<FirebaseStorageService>();

  @override
  Future<String?> uploadFile(
    String fileName,
    String folderName,
    File file,
  ) async {
    return await _service.uploadFile(fileName, folderName, file);
  }
}
