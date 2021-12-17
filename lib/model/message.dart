class Message {
  static const String contentKey = 'content';
  static const String senderIdKey = 'senderId';
  static const String receiverIdKey = 'receiverId';
  static const String sentAtKey = 'sentAt';
  static const String isPicKey = 'isPic';
  static const String isSystemMessageKey = 'isSystemMessage';

  late String senderId;
  late String receiverId;
  late String content;
  DateTime? sentAt;
  late bool isOwnMessage;
  late bool isPic;
  late bool isSystemMessage;

  Message({
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.isPic,
    required this.isSystemMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      contentKey: this.content,
      senderIdKey: this.senderId,
      receiverIdKey: this.receiverId,
      isPicKey:this.isPic,
      isSystemMessageKey:this.isSystemMessage,
    };
  }

  Message.fromMap(Map<String, dynamic> map, isOwnMessage) {
    this.content = map[contentKey];
    this.senderId = map[senderIdKey];
    this.receiverId = map[receiverIdKey];
    this.sentAt = map[sentAtKey];
    this.isOwnMessage = isOwnMessage;
    this.isPic=map[isPicKey];
    this.isSystemMessage =map[isSystemMessageKey];
  }
}
