import 'package:flutter/material.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/firebase_database_repository.dart';
import 'package:uydu/repository/storage_repository.dart';
import 'package:uydu/repository/user_database_repository.dart';

enum ArtisanState { Loading, Idle }

class ListArtisanByCategorViewModel extends ChangeNotifier {
  AuthRepository _authRepository = locator<AuthRepository>();
  StorageRepository _storageRepository = locator<StorageRepository>();
  UserDatabaseRepository _userDatabaseRepository =
      locator<UserDatabaseRepository>();
  FirebaseDatabaseRepository _firebaseDatabaseRepository =
      locator<FirebaseDatabaseRepository>();

  ListArtisanByCategorViewModel({String? category}) {
    getAllArtisanByCategory(category!);
  }

  ArtisanState _artisanState = ArtisanState.Idle;

  List<User?> users = [];

  getAllArtisanByCategory(category) async {
    _artisanState = ArtisanState.Loading;
    notifyListeners();
    try {
      users = await _userDatabaseRepository.getArtisansByCategory(category);
      _artisanState = ArtisanState.Idle;
      notifyListeners();
    } catch (e) {
      print("ListArtisanPage / getAllArtisanByCategory $e ");
      _artisanState = ArtisanState.Idle;
      notifyListeners();
    }
  }

  openArtisanProfile(BuildContext context, String userId) {
    Routes.openProfilePage(false, userId);
  }
}
