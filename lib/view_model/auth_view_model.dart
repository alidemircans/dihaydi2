import 'dart:io';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:uydu/helper/constants.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/firebase_database_repository.dart';
import 'package:uydu/repository/storage_repository.dart';
import 'package:uydu/repository/user_database_repository.dart';
import 'package:uydu/service/notification_service.dart';
import 'package:uydu/widgets/loading_dialog.dart';
import 'package:uydu/widgets/photo_select_bottom_sheet.dart';

enum RegisterViewState { Idle, Loading }
enum LoginViewState { Idle, Loading }

class AuthViewModel extends ChangeNotifier {
  RegisterViewState _registerViewState = RegisterViewState.Idle;
  RegisterViewState get registerViewState => _registerViewState;
  set registerViewState(RegisterViewState value) {
    _registerViewState = value;
    notifyListeners();
  }

  AuthViewModel() {
    getAllCategories();
    getLocationData();
  }
  LoginViewState _loginViewState = LoginViewState.Idle;

  LoginViewState get loginViewState => _loginViewState;

  set loginViewState(LoginViewState value) {
    _loginViewState = value;
    notifyListeners();
  }

  AuthRepository _authRepository = locator<AuthRepository>();
  FirebaseDatabaseRepository _firebaseDatabaseRepository =
      locator<FirebaseDatabaseRepository>();

  StorageRepository _storageRepository = locator<StorageRepository>();
  UserDatabaseRepository _userDatabaseRepository =
      locator<UserDatabaseRepository>();

  File? _photo;

  File? get photo => _photo;
  Location location = new Location();

  LocationData? locationData;

  getLocationData() async {
    locationData = await location.getLocation();
  }

  void setPhoto(BuildContext context, File? value) {
    _photo = value;
    notifyListeners();
  }

  List<CategoryModel?> categories = [];
  List<CategoryModel?> selectedCategories = [];

  getAllCategories() async {
    categories = await _firebaseDatabaseRepository.getAllCategories();
    notifyListeners();
  }

  onSelectedCategory(CategoryModel? category) {
    selectedCategories.contains(category)
        ? selectedCategories.remove(category)
        : selectedCategories.add(category);
    notifyListeners();
  }

  void onProfilePhotoPressed(BuildContext context) async {
    File? pickedFile =
        await PhotoSelectBottomSheet.open(context, false, false, "");
    if (pickedFile != null) {
      print("Picked file geldi");
      setPhoto(context, File(pickedFile.path));
    } else {
      print("Resim null dönüyor");
    }
  }

  bool get photoSelected => photo != null;

  singUpButtonOnPressed(BuildContext context, email, password, name, phone,
      adress, bool isArtian, List<CategoryModel?> categories) {
    _signUpWithEmailAndPassword(
        context, email, password, name, phone, adress, isArtian, categories);
  }

  onUpdateButtonPressed(BuildContext context, name, phone, adress) {
    updadteProfile(context, name, phone, adress);
  }

  _navigateToCustomerPage(BuildContext context, User? user) {
    Routes.openCustomerHomePage(context, user);
  }

  _navigateToArtisanPage(BuildContext context, User? user) {
    Routes.openArtisanHomePage(context, user);
  }

  Future<bool> updadteProfile(context, name, phone, adress) async {
    print("Güncellenecek isim $name");
    print("Güncellenecek telefon $phone");
    print("Güncellenecek adres $adress");
    String? userId = await _authRepository.getCurrentUserId();
    if (userId != null) {
      print("Güncellenecek userıd $userId");

      bool isOk = false;
      try {
        Map<String, dynamic> data = {
          User.displayNameKey: name,
          User.phoneKey: phone,
          User.adressKey: adress,
        };
        isOk = await _userDatabaseRepository.updateUser(userId, data);
      } catch (e) {
        print("eRROR $e");
      }
      if (isOk) {
        print("Buraya giriyor..");
        Navigator.pop(context);

        SnackBar snackBar =
            SnackBar(content: Text("Profile Başarıyla Güncellendi"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print("else giriyor..");

        print("$isOk");
        Navigator.pop(context);

        SnackBar snackBar = SnackBar(content: Text("Sorun oluştu"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return true;
  }

  Future _signUpWithEmailAndPassword(BuildContext context, email, password,
      name, phone, adress, isArisan, List<CategoryModel?> categories) async {
    registerViewState = RegisterViewState.Loading;
    LoadingDialog dialog = LoadingDialog(
      loadingText: "Kayıt olunuyor...",
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );

    List<String?> tempCategories = [];

    for (var x in categories) {
      if (x != null) {
        tempCategories.add(x.id);
      } else {
        print("X BURADA NULL GELDİ");
      }
    }

    try {
      User? user = await _authRepository.signUpWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        user.displayName = name;
        if (adress != null) user.adress = adress;
        if (phone != null) user.phone = phone;
        if (categories.isNotEmpty) user.categories = tempCategories;
        if (locationData != null) user.lat = locationData!.latitude.toString();
        if (locationData != null)
          user.long = locationData!.longitude.toString();

        user.isArtisan = isArisan;

        if (_photo != null) {
          String? photoUrl = await _storageRepository.uploadFile(
            user.userId,
            Constants.PROFILE_PHOTOS_FOLDER_NAME,
            _photo!,
          );
          user.photoUrl = photoUrl!;
        } else {
          user.photoUrl =
              "https://firebasestorage.googleapis.com/v0/b/sirius-5ed2a.appspot.com/o/app_asset%2Fprofile_photo_placeholder.png?alt=media&token=dfec45d1-845c-45b8-978b-3b522985be46";
        }
        bool isAdded = await _userDatabaseRepository.addUser(user);
        if (isAdded) {
          NotificationService.init(context);

          registerViewState = RegisterViewState.Idle;
          dialog.cancel(context);
          user.isArtisan
              ? _navigateToArtisanPage(context, user)
              : _navigateToCustomerPage(context, user);
        } else {
          dialog.cancel(context);
          String errorMessage =
              _authRepository.getErrorMessage(context, "Bir sorun oluştu!");
          SnackBar snackBar = SnackBar(content: Text(errorMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        registerViewState = RegisterViewState.Idle;
        dialog.cancel(context);
      }
    } catch (e) {
      registerViewState = RegisterViewState.Idle;
      debugPrint(
        "AuthViewModel / signUpWithEmailAndPassword: ${e.toString()}",
      );
      dialog.cancel(context);
      String errorMessage = _authRepository.getErrorMessage(context, e);
      SnackBar snackBar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, email, password) async {
    loginViewState = LoginViewState.Loading;
    LoadingDialog dialog = LoadingDialog(
      loadingText: 'Giriş yapılıyor...',
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );
    try {
      User? user = await _authRepository.signInWithEmailAndPassword(
        email,
        password,
      );

      loginViewState = LoginViewState.Idle;
      dialog.cancel(context);
      if (user != null) {
        NotificationService.init(context);
        print("User not  null ${user.userId}");

        User? userWithAllData =
            await _userDatabaseRepository.getUser(user.userId);

        if (userWithAllData != null) {
          !userWithAllData.isArtisan
              ? _navigateToCustomerPage(context, userWithAllData)
              : _navigateToArtisanPage(context, userWithAllData);
        }
      } else {
        SnackBar snackBar = SnackBar(content: Text("Kullanıcı Yok"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      loginViewState = LoginViewState.Idle;
      dialog.cancel(context);
      debugPrint(
        'AuthViewModel / signInWithEmailAndPassword: ${e.toString()}',
      );
      String errorMessage = _authRepository.getErrorMessage(context, e);
      SnackBar snackBar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
