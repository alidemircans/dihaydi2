import 'package:flutter/material.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/repository/firebase_database_repository.dart';
import 'package:uydu/repository/user_database_repository.dart';
import 'package:uydu/widgets/loading_dialog.dart';
import 'package:uydu/widgets/result_dialog.dart';

enum CategoriesState { Loading, Idle }

class ArtisanHomeViewModel extends ChangeNotifier {
  UserDatabaseRepository _userDatabaseRepository =
      locator<UserDatabaseRepository>();
  FirebaseDatabaseRepository _firebaseDatabaseRepository =
      locator<FirebaseDatabaseRepository>();
  ArtisanHomeViewModel(User? incomingUser, String? requestId) {
    this.user = incomingUser;
    getAllCategories();
    if (requestId != null && requestId != "") setRequestId(requestId);
  }

  CategoriesState _categoriesState = CategoriesState.Idle;

  get categoriesState => _categoriesState;

  initPage() async {
    getAllCategories();
    getUser(user!.userId);
  }

  String? inComingRequetId;

  setRequestId(requestId) {
    inComingRequetId = requestId;
  }

  User? user;

  List<CategoryModel?> categories = [];
  List<dynamic> selectedCategories = [];

  getUser(userId) async {
    user = await _userDatabaseRepository.getUser(userId);
    notifyListeners();
  }

  getAllCategories() async {
    categories = await _firebaseDatabaseRepository.getAllCategories();
    print("User catigories " + user!.categories!.toString());
    selectedCategories = user!.categories!;
    notifyListeners();
  }

  updateCategories(context) async {
    LoadingDialog dialog = LoadingDialog(
      loadingText: 'Kategori Ekleniyor..',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return dialog;
      },
    );
    print("Çalışıyr..");
    _categoriesState = CategoriesState.Loading;
    notifyListeners();
    try {
      Map<String, dynamic> data = {User.categoriesKey: selectedCategories};
      bool isOk = await _userDatabaseRepository.updateUser(user!.userId, data);
      //initPage();
      if (isOk) {
        _categoriesState = CategoriesState.Idle;
        dialog.cancel(context);

        ResultDialog resultDialog = ResultDialog(
          loadingText: 'Kategori Güncellendi..',
          isOk: true,
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return resultDialog;
          },
        );
        await Future.delayed(Duration(seconds: 1));
        resultDialog.cancel(context);
      } else {
        _categoriesState = CategoriesState.Idle;
        dialog.cancel(context);

        ResultDialog resultDialog = ResultDialog(
          loadingText: 'Kategori Eklenemedi..',
          isOk: false,
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return resultDialog;
          },
        );
        await Future.delayed(Duration(seconds: 1));
        resultDialog.cancel(context);
      }
      notifyListeners();
    } catch (e) {
      print("Some Error $e");
      dialog.cancel(context);
      _categoriesState = CategoriesState.Idle;
      notifyListeners();
    }
  }

  onSelectedCategory(String? categoryId) {
    selectedCategories.contains(categoryId)
        ? selectedCategories.remove(categoryId)
        : selectedCategories.add(categoryId);
    notifyListeners();
  }

  openProfilePage(BuildContext context) {
    print("User Id ${user!.userId}");
    Routes.openProfilePage(true, user!.userId);
  }

  openOtherProfilePage(context, userId) {
    Routes.openProfilePage(false, userId);
  }

  openAllChatsPage(BuildContext context) {
    Routes.openAllChatsPage(context);
  }
}
