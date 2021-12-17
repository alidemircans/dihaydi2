import 'package:flutter/material.dart';
import 'package:uydu/base/auth_base.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/service/auth_service.dart';
import 'package:uydu/service/base/auth_base_service.dart';

class AuthRepository implements AuthBase {
  AuthService _service = locator<FirebaseAuthService>();

  @override
  User? getCurrentUser() {
    return _service.getCurrentUser();
  }

  @override
  bool isSignedIn() {
    return _service.isSignedIn();
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    return await _service.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    return await _service.signUpWithEmailAndPassword(email, password);
  }

  @override
  Future<void> resetPassword(String email) async {
    return await _service.resetPassword(email);
  }

  @override
  Future<String?> getCurrentUserId() async {
    return await _service.getCurrentUserId();
  }

  @override
  Future<bool> signOut() async {
    return await _service.signOut();
  }

  @override
  String getErrorMessage(BuildContext context, Object e) {
    return _service.getErrorMessage(context, e);
  }
}
