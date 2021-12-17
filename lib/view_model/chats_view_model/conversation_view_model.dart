import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uydu/helper/constants.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/model/message.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/conversation_repository.dart';
import 'package:uydu/repository/storage_repository.dart';
import 'package:uydu/view/common/photo_select_bottom_sheet.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:uydu/widgets/loading_dialog.dart';

import '../../helper/routes.dart';

enum ConversationState { Idle, LoadingConversation, Error }

class ConversationViewModel with ChangeNotifier {
  AuthRepository _authRepository = locator<AuthRepository>();

  StorageRepository _service = locator<StorageRepository>();

  ConversationRepository _conversationRepository =
      locator<ConversationRepository>();

  //File? _image;
  //File? get image => _image;

  final imagePicker = ImagePicker();

  getImagesFromCamera(BuildContext context, String conversationId,
      String senderId, String receiverid) async {
    try {
      File? image = await PhotoSelectBottomSheet.open(context, true, false, "");

      if (image != null) {
        LoadingDialog dialog = LoadingDialog(
          loadingText: "Yükleniyor...",
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return dialog;
          },
        );

        String? imageDownloadUrl = await _service.uploadFile(
          DateTime.now().toString(),
          '${Constants.CONVERSATION_PHOTOS_FOLDER_NAME}/$conversationId',
          image,
        );

        if (imageDownloadUrl != null) {
          Message message = Message(
              content: imageDownloadUrl.toString(),
              isPic: true,
              senderId: senderId,
              receiverId: receiverid,
              isSystemMessage: false);
          sendNewMessage(conversationId, message);
          dialog.cancel(context);
        } else {
          SnackBar snackBar = SnackBar(
            content: Text("Tekrar deneyin"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        print("ConversationViewModel/getImagesFromCamera => Image return null");
      }
    } catch (e) {
      debugPrint(
          "ConversationViewModel / getImagesFromCamera: ${e.toString()}");
    }
  }

  List<Message?> _messages = [];
  List<Message?> get messages => _messages;

  Stream<List<Message?>> getSingleConversation(conversationId) async* {
    String? userId = await _authRepository.getCurrentUserId();

    if (userId != null) {
      yield* _conversationRepository.getSingleConversation(
          conversationId, userId);
    }
  }

  sendNewMessage(conversationId, Message message) async {
    String? senderId = await _authRepository.getCurrentUserId();
    if (senderId != null) {
      message.senderId = senderId;
      await _conversationRepository.sendNewMessage(conversationId, message);
    }
  }

  ConversationState _state = ConversationState.LoadingConversation;

  ConversationState get state => _state;

  set state(ConversationState value) {
    _state = value;
    notifyListeners();
  }

  openImageReveviewPage(BuildContext context, String url) async {
    Routes.openImageReveviewPage(context, url);
  }
  openProfilePage(context,userId){  
    Routes.openProfilePage(false, userId);
  }

  void onBackButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
