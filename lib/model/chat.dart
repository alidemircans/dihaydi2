
import 'package:uydu/model/user.dart';

class Chat {
  late String id;
  late User? user;
  late String? senderId;
  late String? message;
  late int? unReadMessageCount;
  late bool isOwnMessage;
  late DateTime? sentAt;
  late bool isPic;

  Chat({
    required this.id,
    required this.user,
    required this.message,
    required this.unReadMessageCount,
    required this.isOwnMessage,
    required this.sentAt,
    required this.senderId,
    required this.isPic,
  });

  Chat.witoutUser({
    required this.id,
    required this.message,
    required this.unReadMessageCount,
    required this.isOwnMessage,
  });

  Chat.fromModel(
      {id, user, message, unReadMessageCount, isOwnMessage, sentAt, senderId,isPic}) {
    this.id = id;
    this.user = user;
    this.message = message;
    this.unReadMessageCount = unReadMessageCount;
    this.isOwnMessage = isOwnMessage;
    this.sentAt = sentAt;
    this.senderId = senderId;
    this.isPic=isPic;
  }
}
