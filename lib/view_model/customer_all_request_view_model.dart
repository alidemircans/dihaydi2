import 'package:flutter/material.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/brand.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/customer_request_model.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/firebase_database_repository.dart';
import 'package:uydu/repository/user_database_repository.dart';

enum AllRequestState { Loading, Idle }

class CustomerAllRequestViewModel extends ChangeNotifier {
  AuthRepository _authRepository = locator<AuthRepository>();
  UserDatabaseRepository _userDatabaseRepository =
      locator<UserDatabaseRepository>();
  FirebaseDatabaseRepository _firebaseDatabaseRepository =
      locator<FirebaseDatabaseRepository>();

  AllRequestState allRequestState = AllRequestState.Idle;

  CustomerAllRequestViewModel(String userId) {
    getUser(userId);
    getAllRequest();
  }

  User? user;
  bool? isOwnProfile;

  getUser(String isUserId) async {
    try {
      user = await _userDatabaseRepository.getUser(isUserId);
      notifyListeners();
    } catch (e) {
      print("CustomerAllRequestViewModel / getUser $e");
    }
  }

  initPage() {
    requests.clear();
    getAllRequest();
  }

  CategoryModel? inComingCategoryModel;

  BrandModel? selecetedBrand;
  String? _description;

  get description => _description;

  set descriptionSet(val) {
    _description = val;
    notifyListeners();
  }

  List<CustomerRequestModel?> requests = [];

  getAllRequest() async {
    String? userId = await _authRepository.getCurrentUserId();

    if (userId != null) {
      allRequestState = AllRequestState.Loading;
      notifyListeners();
      try {
        requests =
            await _firebaseDatabaseRepository.getAllRequestByUser(userId);
        allRequestState = AllRequestState.Idle;
        print("Requestler geldi ${requests.length}");
        notifyListeners();
      } catch (e) {
        print("CustomerAllRequestViewModel / getAllRequest $e");
        allRequestState = AllRequestState.Idle;
      }
    }
  }

  cancelJob(context, String requestId) async {
    try {
      bool isOK = await _firebaseDatabaseRepository.cancelRequest(requestId);
      if (isOK) {
        SnackBar snackBar = SnackBar(content: Text("İş İptal Edildi"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        getAllRequest();
      } else {
        SnackBar snackBar = SnackBar(content: Text("Bir sorun oluştu"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      notifyListeners();
    } catch (e) {
      print("CustımerAllRequestViewModel / finishJoob $e");
    }
  }

  openOtherProfilePage(context, userId) {
    Routes.openProfilePage( false, userId);
  }
}
