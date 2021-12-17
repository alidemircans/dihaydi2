import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uydu/model/chat.dart';
import 'package:uydu/model/conversation.dart';
import 'package:uydu/model/message.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/service/base/conversation_service.dart';

class ConversationDatabaseService extends ConversationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _conversationCollectionName = "conversation";
  final String _conversationMessagesCollectionName = "messages";
  final String _usersCollectionName = "users";

  @override
  markAsReadMessages(Chat? chat, userId) async {
    if (chat != null) {
      try {
        if (!chat.isOwnMessage) {
          await _firestore
              .collection(_conversationCollectionName)
              .doc(chat.id)
              .update(
            {
              Conversation.unReadKey: 0,
            },
          );
        }
      } catch (error) {
        print(
          "ConversationDatabaseService / markAsReadMessages : ${error.toString()}",
        );
      }
    }
  }

  @override
  Future sendNewMessage(String conversationId, Message? message) async {
    if (message != null) {
      Map<String, dynamic> messageMap = message.toMap();
      messageMap[Message.sentAtKey] = FieldValue.serverTimestamp();

      try {
        await _firestore
            .collection(_conversationCollectionName +
                '/' +
                conversationId +
                '/' +
                _conversationMessagesCollectionName)
            .doc()
            .set(messageMap);
        await _firestore
            .collection(_conversationCollectionName)
            .doc(conversationId)
            .update(
          {
            Conversation.lastMessageKey: message.content,
            Conversation.sentAtKey: FieldValue.serverTimestamp(),
            Conversation.lastUserIdKey: message.senderId,
            Conversation.unReadKey: FieldValue.increment(1),
            Message.isPicKey: message.isPic,
            Message.isSystemMessageKey: false
          },
        );
      } catch (error) {
        print(
          "ConversationDatabaseService / sendNewMessage : ${error.toString()}",
        );
      }
    }
  }

  @override
  Stream<List<Chat?>> getAllConversation(String userId) async* {
    Stream<List<Conversation?>> conversationStream = _firestore
        .collection(_conversationCollectionName)
        .where(
          Conversation.memebersKey,
          arrayContains: userId,
        )
        .orderBy(Conversation.sentAtKey, descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => _getConversationFromDocumentSnapshot(e, e.id))
            .toList());

    Stream<List<User?>> userStream =
        _firestore.collection(_usersCollectionName).snapshots().map((event) {
      return event.docs.map((e) {
        try {
          return _getUserFromDocumentSnapshot(e);
        } catch (eror) {
          print("There is an error for user => $eror ${e.data()["userId"]}");
        }
      }).toList();
    });

    yield* Rx.combineLatest2(
      conversationStream,
      userStream,
      (List<Conversation?> conversations, List<User?> users) {
        return conversations.map((conversation) {
          if (conversation != null) {
            var otherUser = conversation.memebers[0] == userId
                ? conversation.memebers[1]
                : conversation.memebers[0];

            bool isOwnMessage =
                conversation.lastUserId == userId ? true : false;
            User? user = users.firstWhere((user) {
              return user!.userId == otherUser;
            });

            return Chat(
              id: conversation.conversationId,
              user: user,
              message: conversation.lastMessages,
              unReadMessageCount: isOwnMessage ? 0 : conversation.unRead,
              isOwnMessage: isOwnMessage,
              sentAt: conversation.sentAt,
              senderId: userId,
              isPic: conversation.isPic,
            );
          } else {
            print('Conversation is Null');
          }
        }).toList();
      },
    );
  }

  @override
  Stream<List<Message?>> getSingleConversation(conversationId, userId) async* {
    yield* _firestore
        .collection(_conversationCollectionName +
            '/' +
            conversationId +
            '/' +
            _conversationMessagesCollectionName)
        .orderBy(
          Message.sentAtKey,
        )
        .snapshots()
        .map((event) => event.docs
            .map((e) => _getMessageFromDocumentSnapshot(e, userId))
            .toList());
  }

  User? _getUserFromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic>? userMap = doc.data();
    if (userMap != null) {
      userMap[User.sentAtKey] = (userMap[User.sentAtKey] as Timestamp).toDate();
      return User.fromMap(doc.id, userMap);
    }
    return null;
  }

  Conversation? _getConversationFromDocumentSnapshot(
      DocumentSnapshot doc, conversationId) {
    Map<String, dynamic>? conversationMap = doc.data();
    if (conversationMap != null) {
      //if (!doc.metadata.hasPendingWrites) {
      conversationMap[Message.sentAtKey] =
          (conversationMap[Message.sentAtKey] as Timestamp).toDate();
      //}
      Conversation conversation =
          Conversation.fromMap(conversationMap, conversationId);
      return conversation;
    }
    return null;
  }

  Message? _getMessageFromDocumentSnapshot(DocumentSnapshot doc, userId) {
    Map<String, dynamic>? messageMap = doc.data();
    if (messageMap != null) {
      //if (!doc.metadata.hasPendingWrites) {
      messageMap[Message.sentAtKey] =
          (messageMap[Message.sentAtKey] as Timestamp).toDate();
      //}
      bool isOwnMessage = messageMap[Message.senderIdKey] == userId;
      Message m = Message.fromMap(messageMap, isOwnMessage);
      return m;
    }
    return null;
  }

  @override
  Future<bool> startConversation(
    List members,
  ) async {

    bool isOk = true;
    // my id => members[0]
    // other user => members[1]

    try {
      var count = 0;
      var allMyConversation = await _firestore
          .collection(_conversationCollectionName)
          .where(
            Conversation.memebersKey,
            arrayContains: members[0],
          )
          .orderBy(
            Conversation.sentAtKey,
          )
          .get();

      for (var singleMyConversation in allMyConversation.docs) {
        if (singleMyConversation.data()["members"].contains(members[1])) {
          count++;
        }
      }

      if (count == 0) {
        print("Conversation starting...");
        var message = Message(
          content: "Artık konuşmaya başlayabilirsiniz!",
          senderId: members[0],
          receiverId: members[1],
          isPic: false,
          isSystemMessage: true,
        );
        Map<String, dynamic> messageMap = message.toMap();
        messageMap[Message.sentAtKey] = FieldValue.serverTimestamp();
        DocumentReference docRefConversation = FirebaseFirestore.instance
            .collection(_conversationCollectionName)
            .doc();

        await _firestore
            .collection(_conversationCollectionName +
                '/' +
                docRefConversation.id +
                '/' +
                _conversationMessagesCollectionName)
            .doc()
            .set(messageMap);
        await _firestore
            .collection(_conversationCollectionName)
            .doc(docRefConversation.id)
            .set(
          {
            Conversation.lastMessageKey: message.content,
            Conversation.sentAtKey: FieldValue.serverTimestamp(),
            Conversation.lastUserIdKey: members[0],
            Conversation.unReadKey: 1,
            Message.isPicKey: message.isPic,
            Message.isSystemMessageKey: message.isSystemMessage,
            Conversation.memebersKey: members
          },
        );
      } else {
        print("You are already has conversation with this user..");
      }
    } catch (error) {
      print(
        "ConversationDatabaseService / startConversation : ${error.toString()}",
      );
      isOk =false;
    }
    return isOk;
  }

  @override
  Future<List<User?>> getAllConversationsUser(String userId) async {
    List<User?> userList = [];
    QuerySnapshot allConversation = await _firestore
        .collection(_conversationCollectionName)
        .where(
          Conversation.memebersKey,
          arrayContains: userId,
        )
        .orderBy(Conversation.sentAtKey, descending: true)
        .get();

    for (var singleConversation in allConversation.docs) {
      var circleUserId =
          singleConversation.data()[Conversation.memebersKey][0] == userId
              ? singleConversation.data()[Conversation.memebersKey][1]
              : singleConversation.data()[Conversation.memebersKey][0];

      if (circleUserId != null) {
        DocumentSnapshot userDocumentSnapshot = await _firestore
            .collection(_usersCollectionName)
            .doc(circleUserId)
            .get();
        User? user = _getUserFromDocumentSnapshot(userDocumentSnapshot);
        userList.add(user);
      }
    }

    return userList;
  }

  @override
  Stream<int> getUnReadMessageCount(String? userId) async* {
    int total = 0;
    yield* _firestore
        .collection(_conversationCollectionName)
        .where(Conversation.memebersKey, arrayContains: userId)
        .where(
          Conversation.unReadKey,
          isGreaterThan: 0,
        )
        .snapshots()
        .map((event) {
      total = 0;
      for (var data in event.docs) {
        if (data[Conversation.lastUserIdKey] != userId) total++;
      }
      return total;
    });
  }
}
