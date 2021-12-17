import 'package:uydu/base/conversation_base.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/model/chat.dart';
import 'package:uydu/model/message.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/service/base/conversation_service.dart';
import 'package:uydu/service/conversation_database_service.dart';

class ConversationRepository implements ConversationBase {
  ConversationService _service = locator<ConversationDatabaseService>();

  @override
  Stream<List<Chat?>> getAllConversation(String userId) async* {
    yield* _service.getAllConversation(userId);
  }

  @override
  Stream<List<Message?>> getSingleConversation(
      String conversationId, String userId) async* {
    yield* _service.getSingleConversation(conversationId, userId);
  }

  @override
  Future sendNewMessage(String conversationId, Message? message) async {
    return _service.sendNewMessage(conversationId, message);
  }

  @override
  markAsReadMessages(Chat? chat, userId) {
    return _service.markAsReadMessages(chat, userId);
  }

  @override
  Future<bool> startConversation(List members) async {
    return await _service.startConversation(members);
  }

  @override
  Future<List<User?>> getAllConversationsUser(String userId) async {
    return await _service.getAllConversationsUser(userId);
  }

  @override
  Stream<int> getUnReadMessageCount(String? userId) async* {
    yield*  _service.getUnReadMessageCount(userId);
  }
}
