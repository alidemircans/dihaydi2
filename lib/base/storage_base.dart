import 'dart:io';

abstract class StorageBase {
  Future<String?> uploadFile(
    String fileName,
    String folderName,
    File file,
  );
}
