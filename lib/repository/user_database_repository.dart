import 'package:uydu/base/user_database_base.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/service/base/user_database_service.dart';
import 'package:uydu/service/user_database_service_firestore.dart';

class UserDatabaseRepository implements UserDatabaseBase {
  UserDatabaseService _service = locator<FirestoreUserDatabaseService>();

  @override
  Future<User?> getUser(String userId) async {
    return await _service.getUser(userId);
  }

  @override
  Future<bool> addUser(User user) async {
    return await _service.addUser(user);
  }

  @override
  Future<bool> updateUser(
    String userId,
    Map<String, dynamic> newValues,
  ) async {
    return await _service.updateUser(userId, newValues);
  }

  @override
  Future addUserDeviceToken(String? token) async {
    return await _service.addUserDeviceToken(token);
  }

  @override
  Future< List<User?>> getArtisansByCategory(String category)async {
    return await _service.getArtisansByCategory(category);
   
  }

  @override
  Future<String?> getIban(String userId)async{
    return await _service.getIban(userId);
  }

  @override
  Future<bool> updateUserIban(String userId, String iban)async {
   return await _service.updateUserIban(userId, iban);
  }
  
}
