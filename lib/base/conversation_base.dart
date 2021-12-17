import 'package:uydu/model/chat.dart';
import 'package:uydu/model/message.dart';
import 'package:uydu/model/user.dart';

abstract class ConversationBase {
  Future<bool> startConversation(List members);
  markAsReadMessages(Chat? chat, userId);
  Stream<List<Chat?>> getAllConversation(String userId);
  Future<List<User?>> getAllConversationsUser(String userId);
  Stream<List<Message?>> getSingleConversation(
      String conversationId, String userId);
  Future sendNewMessage(String conversationId, Message? message);
  Stream<int> getUnReadMessageCount(String? userId);
}
