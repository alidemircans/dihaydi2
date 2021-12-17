class Conversation {
  static const String memebersKey = 'members';
  static const String unReadKey = 'unRead';
  static const String lastMessageKey = 'lastMessages';
  static const String lastUserIdKey = 'lastUserId';
  static const String sentAtKey = 'sentAt';
  static const String isPicKey = 'isPic';

  late List memebers;
  late int? unRead;
  late String conversationId;
  late String lastMessages;
  late String lastUserId;
  late DateTime sentAt;
  late bool isPic;

  Conversation({
    required this.memebers,
    required this.unRead,
    required this.conversationId,
    required this.lastMessages,
    required this.lastUserId,
    required this.sentAt,
    required this.isPic,
  });

  Conversation.fromMap(Map<String, dynamic> map, conversationId) {
    this.memebers = map[memebersKey];
    this.unRead = map[unReadKey];
    this.lastMessages = map[lastMessageKey];
    this.lastUserId = map[lastUserIdKey];
    this.sentAt = map[sentAtKey];
    this.isPic = map[isPicKey];

    this.conversationId = conversationId;
  }
}
