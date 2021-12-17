import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/helper/constants.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/firebase_database_repository.dart';
import 'package:uydu/repository/storage_repository.dart';
import 'package:uydu/repository/user_database_repository.dart';
import 'package:uydu/widgets/loading_dialog.dart';
import 'package:uydu/widgets/photo_select_bottom_sheet.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/widgets/translataion_widget.dart';

enum ProfileState { Loading, Idle }
enum ProfileIbanState { Loading, Idle }
enum ProfileIbanUpdateState { Loading, Idle }
enum ProfileCategoryState { Loading, Idle }

class ProfilePageViewModel extends ChangeNotifier {
  FirebaseDatabaseRepository _firebaseDatabaseRepository =
      locator<FirebaseDatabaseRepository>();
  AuthRepository _authRepository = locator<AuthRepository>();
  UserDatabaseRepository _userDatabaseRepository =
      locator<UserDatabaseRepository>();
  StorageRepository _storageRepository = locator<StorageRepository>();

  ProfileState profileState = ProfileState.Idle;
  ProfileIbanState profileIbanState = ProfileIbanState.Idle;
  ProfileIbanUpdateState profileIbanUpdateState = ProfileIbanUpdateState.Idle;
  ProfileCategoryState profileCategoryState = ProfileCategoryState.Idle;

  ProfilePageViewModel(bool? inComingisOwnProfile, String userId) {
    isOwnProfile = inComingisOwnProfile;
    if (inComingisOwnProfile!) {
      getUser(userId);
      getIban(userId);
    } else {
      getUser(userId);
      getIban(userId);
    }
  }

  User? user;
  bool? isOwnProfile;
  String? iban;

  List<CategoryModel?> categories = [];

  getIban(userId) async {
    profileIbanState = ProfileIbanState.Loading;
    notifyListeners();
    try {
      if (userId != null) {
        iban = await _userDatabaseRepository.getIban(userId);
        print("İban $iban");
        notifyListeners();
      } else {
        print("User id null döndü");
      }
    } catch (e) {
      print("ProfilePageViewModel / getIban $e");
      profileIbanState = ProfileIbanState.Idle;
    }
  }

  getUser(String isUserId) async {
    String? useUserId = "";
    profileState = ProfileState.Loading;
    notifyListeners();
    try {
      if (isUserId == "") {
        useUserId = await _authRepository.getCurrentUserId();
      } else {
        useUserId = isUserId;
      }

      if (useUserId != null) {
        user = await _userDatabaseRepository.getUser(useUserId);
        getFilteredCategories(user!.categories);
        profileState = ProfileState.Idle;
        notifyListeners();
      }
    } catch (e) {
      print("ProfilePageViewModel / getUser $e");
      profileState = ProfileState.Idle;
    }
  }

  getFilteredCategories(cat) async {
    profileCategoryState = ProfileCategoryState.Loading;
    notifyListeners();
    try {
      categories = await _firebaseDatabaseRepository.getFilteredCategories(cat);
      profileCategoryState = ProfileCategoryState.Idle;
      notifyListeners();
    } catch (e) {
      print("Error $e");
      profileCategoryState = ProfileCategoryState.Idle;
      notifyListeners();
    }
  }

  void onProfilePhotoPressed(
      BuildContext context, String image, bool isProfileImage) async {
    if (user != null) {
      try {
        File? newPhoto =
            await PhotoSelectBottomSheet.open(context, false, true, image);
        if (newPhoto != null) {
          LoadingDialog dialog = LoadingDialog(
            loadingText: "Lütfen bekleyin...",
          );
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return dialog;
            },
          );
          String? photoUrl = await _storageRepository.uploadFile(
            user!.userId,
            Constants.PROFILE_PHOTOS_FOLDER_NAME,
            newPhoto,
          );
          dialog.cancel(context);
          if (photoUrl != null) {
            bool result = await updateUserPhotoUrl(
              context,
              user!.userId,
              photoUrl,
            );

            if (result) {
              user!.photoUrl = photoUrl;

              user = user;
              notifyListeners();
            }
          } else {
            SnackBar snackBar = SnackBar(
              content: Text("Bir sorun oluştu, lütfen tekrar deneyiniz"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      } catch (e) {
        debugPrint("ProfileViewModel / onProfilePhotoPressed: ${e.toString()}");
      }
    }
  }

  Future<bool> updateUserPhotoUrl(
    BuildContext context,
    String userId,
    String value,
  ) async {
    return await _updateUserValue(context, userId, User.photoUrlKey, value);
  }

  Future<bool> _updateUserValue(
    BuildContext context,
    String userId,
    String fieldName,
    dynamic value,
  ) async {
    LoadingDialog dialog = LoadingDialog(
      loadingText: "Lütfen bekleyiniz...",
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );
    try {
      dialog.cancel(context);

      SnackBar snackBar = SnackBar(
        content: Text("Profil resmi başarıyla yüklendi"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return await _userDatabaseRepository.updateUser(userId, {
        fieldName: value,
      });
    } catch (e) {
      debugPrint(
        "ProfileDetailViewModel / _updateUserValue: ${e.toString()}",
      );
      SnackBar snackBar = SnackBar(
        content: Text("Bir sorun oluştu.."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    dialog.cancel(context);

    return false;
  }

  void onBackButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  signOut(context) {
    _authRepository.signOut();
    Routes.openSplashScreen(context);
  }

  editProfile(context, name, phone, adress) {
    Routes.openProfileEditScreen(context, name, phone, adress);
  }

  openIbanUpdate(context, userId) async {
    var ibandata = "";
    var error = "";
    await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextStyleGenerator(text: "BANKA "),
                          TextStyleGenerator(text: " IBAN"),
                        ],
                      ),
                    ),
                    TextField(
                      onChanged: (val) {
                        ibandata = val;
                      },
                      // keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        if (ibandata == "") {
                          setState(() {
                            error = "Boş bırakmayınız!";
                          });
                        } else {
                          if (ibandata.substring(0, 2) == "TR") {
                            setState(() {
                              profileIbanUpdateState =
                                  ProfileIbanUpdateState.Loading;
                            });
                            var isOk = await updateUserIban(userId, ibandata);

                            if (isOk) {
                              setState(() {
                                profileIbanUpdateState =
                                    ProfileIbanUpdateState.Idle;
                              });
                              iban = ibandata;
                              notifyListeners();
                              print("İs ok true döndü");
                              Navigator.pop(context);
                              SnackBar snackBar = SnackBar(
                                content: Text("Güncellendi"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              setState(() {
                                profileIbanUpdateState =
                                    ProfileIbanUpdateState.Idle;
                              });
                              print("Problem");
                            }
                          } else {
                            setState(() {
                              error = "Iban TR ile başlamalıdır";
                            });
                          }
                        }
                      },
                      child: Container(
                        color: Colors.lightBlue,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Center(
                          child: profileIbanUpdateState ==
                                  ProfileIbanUpdateState.Loading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : TextStyleGenerator(
                                  text: "Güncelle",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextStyleGenerator(
                      text: error.toString(),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              )),
        );
      }),
    );
  }

  Future<bool> updateUserIban(userId, iban) async {
    bool isOk = true;
    profileIbanUpdateState = ProfileIbanUpdateState.Loading;
    notifyListeners();

    try {
      isOk = await _userDatabaseRepository.updateUserIban(userId, iban);
      profileIbanUpdateState = ProfileIbanUpdateState.Idle;
      notifyListeners();
    } catch (e) {
      isOk = false;
      print("ProfileViewModel /updateUserIban $e ");
      profileIbanUpdateState = ProfileIbanUpdateState.Idle;
      notifyListeners();
    }
    print("isOk $isOk");
    return isOk;
  }

  makePay(context,List<CategoryModel?> categories) {
    Routes.openPayPage(context, categories);
  }
}
