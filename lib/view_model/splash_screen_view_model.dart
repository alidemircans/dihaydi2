import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/user_database_repository.dart';

enum SplashViewState { Idle, Animated }

class SplashViewModel with ChangeNotifier {
  AuthRepository _authRepository = locator<AuthRepository>();
  UserDatabaseRepository _userDatabaseRepository =
      locator<UserDatabaseRepository>();

  SplashViewState _state = SplashViewState.Idle;

  SplashViewState get state => _state;

  set state(SplashViewState value) {
    _state = value;
    notifyListeners();
  }

  navigate(BuildContext context) {
    _checkConnectivity().then((bool isConnected) {
      if (isConnected) {
        _checkIsSignedIn(context);
      } else {
        SnackBar snackBar = SnackBar(
          content: Text("Please check your network connection"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Future<bool> _checkConnectivity() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  _checkIsSignedIn(BuildContext context) async {
    if (_authRepository.isSignedIn()) {
      await _checkUserAtDatabase(context);
    } else {
      state = SplashViewState.Animated;
    }
  }

  Future<void> _checkUserAtDatabase(BuildContext context) async {
    User? currentUser = _authRepository.getCurrentUser();
    if (currentUser != null) {
      User? dbUser = await _userDatabaseRepository.getUser(currentUser.userId);
      if (dbUser != null) {
        !dbUser.isArtisan
            ? _openCustomerHomePage(context, dbUser)
            : _navigateToArtisanPage(context, dbUser);
      } else {
        // Routes.openRegisterFlowFromSocialLogin(context, currentUser);
        _authRepository.signOut();
        _openSplashScreen(context);
      }
    }
  }

  openLoginPage(BuildContext context) {
    Routes.openLoginPage(context, false);
  }

  openRegisterPage(BuildContext context, bool isArtisan) {
    Routes.openRegisterPage(context, isArtisan);
  }

  _openCustomerHomePage(BuildContext context, user) {
    Routes.openCustomerHomePage(context, user);
  }

  _navigateToArtisanPage(BuildContext context, User? user) {
    Routes.openArtisanHomePage(context, user);
  }

  _openSplashScreen(BuildContext context) {
    Routes.openSplashScreen(context);
  }
}
