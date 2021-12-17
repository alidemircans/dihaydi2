import 'package:flutter/material.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/chat.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/conversation_repository.dart';
import 'package:uydu/service/base/user_database_service.dart';
import 'package:uydu/service/user_database_service_firestore.dart';

enum ChatsState { Idle, LoadingAllChats, Error }

class ChatsViewModel with ChangeNotifier {
  AuthRepository _authRepository = locator<AuthRepository>();
  UserDatabaseService _service = locator<FirestoreUserDatabaseService>();

  ConversationRepository _conversationRepository =
      locator<ConversationRepository>();

  List<Chat?> _allChats = [];
  List<Chat?> get chats => _allChats;

  Stream<List<Chat?>> getAllConversation() async* {
    String? userId = await _authRepository.getCurrentUserId();
    if (userId != null) {
      yield* _conversationRepository.getAllConversation(userId);
    }
  }

  getDataFilter(DateTime? chatDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final thirtyDay = DateTime(now.year, now.month, now.day - 30);

    final filterDate = DateTime(chatDate!.year, chatDate.month, chatDate.day);

    final hour = chatDate.hour.toString().length < 2
        ? "0${filterDate.hour}"
        : chatDate.hour.toString();
    final minute = chatDate.minute.toString().length < 2
        ? "0${chatDate.minute}"
        : chatDate.minute.toString();

    final filtredDayDate =
        DateTime(now.year, now.month, now.day - filterDate.day);

    List timeList = [];
    if (filterDate == today) {
      timeList = ["Today", hour, minute];
      return timeList;
    } else if (filterDate == yesterday) {
      timeList = ["Yesterday", hour, minute];
      return timeList;
    } else if (filterDate.isBefore(thirtyDay)) {
      timeList = [filterDate.toString().substring(0, 11), hour, minute];
      return timeList;
    } else {
      timeList = [filtredDayDate.day.toString() + " days", hour, minute];
      return timeList;
    }
  }

  getUser(userId) async {
    await _service.getUser(userId);
  }

  ChatsState _state = ChatsState.LoadingAllChats;

  ChatsState get state => _state;

  set state(ChatsState value) {
    _state = value;
    notifyListeners();
  }

  void onBackButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  openConversationPage(BuildContext context, Chat? chat) async {
    String? userId = await _authRepository.getCurrentUserId();
    _conversationRepository.markAsReadMessages(chat, userId);
    Routes.openConversationPage(context, chat);
  }

  startConversation(String artisanId, context) async {
    String? userId = await _authRepository.getCurrentUserId();
    var members = [userId, artisanId];
    bool isOk = await _conversationRepository.startConversation(members);
    if (isOk)
      openAllChatsPage(context);
    else {
      SnackBar snackBar = SnackBar(content: Text("Sorun oluştu"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  openAllChatsPage(BuildContext context) {
    Routes.openAllChatsPage(context);
  }
}
