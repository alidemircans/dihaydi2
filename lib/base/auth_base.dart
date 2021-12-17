import 'package:flutter/material.dart';
import 'package:uydu/model/user.dart';

abstract class AuthBase {
  Future<String?> getCurrentUserId();
  User? getCurrentUser();
  bool isSignedIn();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(String email, String password);
  Future<void> resetPassword(String email);
  Future<bool> signOut();
  String getErrorMessage(BuildContext context, Object e);
}
