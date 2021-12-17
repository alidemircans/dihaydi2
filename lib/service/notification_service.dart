import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uydu/repository/auth_repository.dart';

import '../helper/locator.dart';
import '../repository/user_database_repository.dart';

class NotificationService {
  static UserDatabaseRepository userDatabaseRepository =
      locator<UserDatabaseRepository>();
  static AuthRepository authRepository = locator<AuthRepository>();

  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static getToken() async {
    String? token = await _firebaseMessaging.getToken();
    await userDatabaseRepository.addUserDeviceToken(token);
  }

  static Future<void> init(context) async {
    _firebaseMessaging.requestPermission();
    getToken();
    FirebaseMessaging.onMessage.listen((event) async {
      Map<String, dynamic> pushData = event.data;

      print("GELEN MESAJIN TYPE ${pushData["type"]} bodysi ise $pushData");

      if (pushData["type"] == "ADMIN") {
        print(pushData);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      Map<String, dynamic> pushData = event.data;

      if (pushData["type"] == "ADMIN") {
        print(pushData);
      }
    });
  }
}
