import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/service/base/user_database_service.dart';

class FirestoreUserDatabaseService implements UserDatabaseService {
  AuthRepository authRepository = locator<AuthRepository>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String usersCollectionName = 'users';
  static const String ibanCollectionName = 'IBANS';

  FirestoreUserDatabaseService() {
    _firestore.settings = Settings(persistenceEnabled: false);
  }
  @override
  Future<String?> getIban(String userId) async {
    var iban = "";
    QuerySnapshot doc = await _firestore
        .collection(ibanCollectionName)
        .where("userId", isEqualTo: userId)
        .get();
    for (var data in doc.docs) {
      iban = data.data()["iban"];
    }
    return iban;
  }

  @override
  Future<User?> getUser(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection(usersCollectionName).doc(userId).get();

    return getUserFromDocumentSnapshot(doc);
  }

  @override
  Future<bool> addUser(User user) async {
    user.sentAt = DateTime.now();
    bool isAdded = true;
    DocumentReference docRefUser = FirebaseFirestore.instance
        .collection(usersCollectionName)
        .doc(user.userId);

    await _firestore.runTransaction((transaction) {
      return transaction.get(docRefUser).then((snapshot) {
        if (snapshot.data() == null) {
          transaction.set(docRefUser, user.toMap());
        }
      });
    }, timeout: const Duration(seconds: 5)).catchError((e) {
      print("FirestoreUserDatabaseService / addUser : ${e.toString()}");
      isAdded = false;
    });
    return isAdded;
  }

  @override
  Future<bool> updateUser(String userId, Map<String, dynamic> newValues) async {
    bool result = true;

    try {
      await _firestore
          .collection(usersCollectionName)
          .doc(userId)
          .update(newValues);
    } catch (e) {
      result = false;
      print('FirestoreUserDatabaseService / updateUser : ${e.toString()}');
    }

    return result;
  }

  @override
  Future<List<User?>> getArtisansByCategory(String category) async {
    List<User?> users = [];
    try {
      QuerySnapshot qs = await _firestore
          .collection(usersCollectionName)
          .where(
            User.categoriesKey,
            arrayContains: category,
          )
          .get();
      for (var data in qs.docs) {
        users.add(getUserFromDocumentSnapshot(data));
      }
    } catch (e) {
      print(
          'FirestoreUserDatabaseService / getArtisansByCategory : ${e.toString()}');
    }
    return users;
  }

  User? getUserFromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic>? userMap = doc.data();
    if (userMap != null) {
      userMap[User.sentAtKey] = (userMap[User.sentAtKey] as Timestamp).toDate();
      return User.fromMap(doc.id, userMap);
    }
    return null;
  }

  @override
  Future addUserDeviceToken(token) async {
    var currentUserId = await authRepository.getCurrentUserId();

    if (currentUserId != null) {
      await _firestore
          .collection(usersCollectionName)
          .doc(currentUserId)
          .update({
            User.deviceTokenKey: token,
          })
          .then((_) {})
          .catchError((e) {
            print(
                'FirestoreUserDatabaseService / addUserDeviceToken : ${e.toString()}');
          });
    } else {
      print("Giriş yapılmamış...");
    }
  }

  @override
  Future<bool> updateUserIban(String userId, String iban) async {
    bool result = true;
    var docId = "";
    print("USER ID $userId");
    try {
      var doc = await _firestore
          .collection(ibanCollectionName)
          .where("userId", isEqualTo: userId)
          .get();
      for (var data in doc.docs) {
        print("Uzunluk" + doc.docs.length.toString());
        docId = data.id;
      }
      if (docId != "") {
        await _firestore
            .collection(ibanCollectionName)
            .doc(docId)
            .update({"iban": iban});
      } else {
        print("DocId boş");
      }
    } catch (e) {
      result = false;
      print('FirestoreUserDatabaseService / updateUserIban : ${e.toString()}');
    }

    return result;
  }
}
