import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/service/base/auth_base_service.dart';

class FirebaseAuthService implements AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User? _currentUser;

  @override
  Future<String?> getCurrentUserId() async {
    String? currentUserId = _currentUser?.userId;
    if (currentUserId != null) {
      return currentUserId;
    }
    auth.User? firebaseUser = _auth.currentUser;
    return firebaseUser?.uid;
  }

  @override
  User? getCurrentUser() {
    auth.User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null && firebaseUser.email != null) {
      return User(firebaseUser.uid, firebaseUser.email!);
    }
    return null;
  }

  @override
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  @override
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    auth.UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    auth.User? firebaseUser = credential.user;
    return _userFromFirebaseUser(firebaseUser);
  }

  @override
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    auth.UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    auth.User? firebaseUser = credential.user;
    return _userFromFirebaseUser(firebaseUser);
  }

  User? _userFromFirebaseUser(
    auth.User? firebaseUser, {
    bool social = false,
  }) {
    User? user;
    if (firebaseUser != null) {
      String? firebaseUserEmail = firebaseUser.email;
      if (firebaseUserEmail != null) {
        user = User(firebaseUser.uid, firebaseUserEmail);
        if (social) {
          String? displayName = firebaseUser.displayName;
          String? photoURL = firebaseUser.photoURL;
          user.displayName = displayName ?? '';
          user.photoUrl = photoURL ?? '';
        }
      }
    }
    return user;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<bool> signOut() async {
    await _auth.signOut();
    return true;
  }

  @override
  String getErrorMessage(BuildContext context, Object e) {
    if (e is auth.FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return "Kullanıcı bulunamadı!";
        case 'wrong-password':
          return "Hatalı bilgi!";
        case 'email-already-in-use':
          return "Bu email zaten kullanılıyor!";
        case 'weak-password':
          return "Zayıf parola";
        default:
          return "Bir hata oluştu tekrar deneyin";
      }
    }
    return "Bir hata oluştu tekrar deneyin";
  }
}
