import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/helper/routes.dart';

class PhotoSelectBottomSheet {
  static Future<File?> open(
    BuildContext context,
    bool isChatPage,
    bool isPofileClicked,
    String image,
  ) async {
    return await showModalBottomSheet<File>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(36)),
      ),
      builder: (BuildContext context) => Card(
        color: ColorHelper.bottomSheetBackgroundColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              _buildBottomSheetTopSymbol(),
              SizedBox(height: 16),
              if (isPofileClicked)
                _buildPreviewPhotoButton(context, "Profil Resmini Görüntüle",
                    () {
                  openUserProfileImagesPreview(context, image);
                }),
              if (isPofileClicked) SizedBox(height: 16),
              if (isPofileClicked) _buildSeperatedpSymbol(context),
              if (isPofileClicked) SizedBox(height: 16),
              _buildSelectPhotoButton(
                context,
                "Galeri",
                () {
                  _chooseImageFromGallery(context);
                },
              ),
              SizedBox(height: 16),
              _buildSelectPhotoButton(
                context,
                "Kamera",
                () {
                  _takePhoto(context);
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  static openUserProfileImagesPreview(context, image) {
    Routes.openImageDetail(context, image);
  }

  static Widget _buildBottomSheetTopSymbol() {
    return Card(
      shape: StadiumBorder(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: ColorHelper.bottomSheetTopSymbolColor,
      child: Container(
        width: 48,
        height: 8,
        color: ColorHelper.bottomSheetTopSymbolColor,
      ),
    );
  }

  static Widget _buildSeperatedpSymbol(context) {
    return Card(
      shape: StadiumBorder(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: ColorHelper.bottomSheetTopSymbolColor,
      child: Container(
        width: MediaQuery.of(context).size.width * .7,
        height: 1,
        color: ColorHelper.bottomSheetTopSymbolColor,
      ),
    );
  }

  static Widget _buildPreviewPhotoButton(
    BuildContext context,
    String text,
    void Function() onPressed,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        child: Text(
          text,
          style: TextStyle(
            color: ColorHelper.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: ColorHelper.bottomSheetBackgroundColor,
          shape: StadiumBorder(
            side: BorderSide(
              width: 2,
              color: ColorHelper.bottomSheetButtonBorderColor,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          //Navigator.pop(context);
          onPressed.call();
        },
      ),
    );
  }

  static Widget _buildSelectPhotoButton(
    BuildContext context,
    String text,
    void Function() onPressed,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        child: Text(
          text,
          style: TextStyle(
            color: ColorHelper.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: ColorHelper.bottomSheetBackgroundColor,
          shape: StadiumBorder(
            side: BorderSide(
              width: 2,
              color: ColorHelper.bottomSheetButtonBorderColor,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          //Navigator.pop(context);
          onPressed.call();
        },
      ),
    );
  }

  static Future<File?> _takePhoto(BuildContext context) async {
    return await _getImage(context, ImageSource.camera);
  }

  static Future<File?> _chooseImageFromGallery(BuildContext context) async {
    return await _getImage(context, ImageSource.gallery);
  }

  static Future<File?> _getImage(
    BuildContext context,
    ImageSource source,
  ) async {
    print("Get image çalıştı");
    ImagePicker imagePicker = ImagePicker();
    try {
      PickedFile? pickedFile;

      pickedFile = await imagePicker.getImage(
        source: source,
      );
      print("geldi $pickedFile");
      if (pickedFile != null) {
        print("pickedFile boş değil::");
        try {
          File? compresedImage =
              await testCompressAndGetFile(File(pickedFile.path));
          Navigator.pop(context, compresedImage);
        } catch (e) {
          print(
              "There is a problem for PhotoSelecetBottomSheet and is not isChatPage /  _getImage.. $e");
        }
      } else {
        print("Resim getirliemedi");
      }
    } catch (e) {
      print(
          "There is a problem for PhotoSelecetBottomSheet /  _getImage..  $e");
    }

    return null;
  }

  static Future<File?> testCompressAndGetFile(File file) async {
    String targetPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(file.path)}');
    print("File is compressing...");
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 35,
      rotate: 0,
    );

    return result;
  }
}
