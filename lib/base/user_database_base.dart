import 'package:uydu/model/user.dart';

abstract class UserDatabaseBase {
  Future<bool> addUser(User user);
  Future addUserDeviceToken(String? token);
  Future<User?> getUser(String userId);
  Future<List<User?>> getArtisansByCategory(String category);
  Future<String?> getIban(String userId);
  Future<bool> updateUser(String userId, Map<String, dynamic> newValues);
  Future<bool> updateUserIban(String userId, String iban);
}
