import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:translator/translator.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/firebase_database_repository.dart';
import 'package:uydu/repository/storage_repository.dart';
import 'package:uydu/repository/user_database_repository.dart';
import 'package:uydu/view_model/language_view_model.dart';

enum CategoryState { Loading, Idle }
enum MarkersState { Loading, Idle }

class CustomerHomeViewModel extends ChangeNotifier {
  AuthRepository _authRepository = locator<AuthRepository>();
  StorageRepository _storageRepository = locator<StorageRepository>();
  UserDatabaseRepository _userDatabaseRepository =
      locator<UserDatabaseRepository>();

  FirebaseDatabaseRepository _firebaseDatabaseRepository =
      locator<FirebaseDatabaseRepository>();

  initPage() async {
    getAllCategories();
    getSliderImages();
  }

  CategoryState categoryState = CategoryState.Idle;
  MarkersState markersState = MarkersState.Idle;

  CustomerHomeViewModel({required User? user}) {
    incomingUser = user;
    getAllCategories();
    getSliderImages();
    getAllArtisan();
  }

  User? incomingUser;

  List<CategoryModel?> categories = [];

  List<User?> allArtisan = [];
  Set<Marker> markers = {};

  getAllCategories() async {
    categoryState = CategoryState.Loading;
    notifyListeners();
    try {
      categories = await _firebaseDatabaseRepository.getAllCategories();
      categoryState = CategoryState.Idle;
      notifyListeners();
    } catch (e) {
      print("CustomerHomeViewModel / getAllCategories $e");
      categoryState = CategoryState.Idle;
    }
  }

  getAllArtisan() async {
    markersState = MarkersState.Loading;
    notifyListeners();
    try {
      allArtisan = await _firebaseDatabaseRepository.getAllArtisan();

      for (var data in allArtisan) {
        var diffLat = double.parse(incomingUser!.lat.toString()) -
            double.parse(data!.lat!);
        var diffLng = double.parse(incomingUser!.long.toString()) -
            double.parse(data.long!);

        if (diffLat <= 0.10 &&
            diffLng <= 0.10 &&
            data.userId == incomingUser!.userId) {
          markers.add(
            Marker(
                infoWindow: InfoWindow(title: data.displayName),
                markerId: MarkerId(data.userId),
                position:
                    LatLng(double.parse(data.lat!), double.parse(data.long!)),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueCyan,
                ),
                onTap: () {
                  print("Own User");
                }),
          );
        }

        if (diffLat <= 0.10 && diffLng <= 0.10 && data.isArtisan) {
          markers.add(
            Marker(
              infoWindow: InfoWindow(title: data.displayName),
              markerId: MarkerId(data.userId),
              position:
                  LatLng(double.parse(data.lat!), double.parse(data.long!)),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueCyan,
              ),
              onTap: () {
                openOtherProfilePage(data.userId);
              },
            ),
          );
        }
      }

      markersState = MarkersState.Idle;
      notifyListeners();
    } catch (e) {
      print("CustomerHomeViewModel / getAllMarkers $e");
      markersState = MarkersState.Idle;
    }
  }

  openOtherProfilePage(userId) {
    Routes.openProfilePage(false, userId);
  }

  getSliderImages() async {
    List<String?> images =
        await _firebaseDatabaseRepository.getAllSliderImages();
    imgList.addAll(images);
    notifyListeners();
  }

  List<String?> imgList = [];

  openListArtisanByCategoryPage(BuildContext context, String? category) async {
    Routes.openListArtisanByCategory(context, category);
  }

  openAllRequestsPage(BuildContext context) async {
    String? userId = await _authRepository.getCurrentUserId();
    if (userId != null) {
      User? user = await _userDatabaseRepository.getUser(userId);
      Routes.openAllRequestesPage(context, false, user, false);
    }
  }

  openProfilePage(BuildContext context) {
    Routes.openProfilePage(true, "");
  }

  openAllChatsPage(BuildContext context) {
    Routes.openAllChatsPage(context);
  }

  signOut(context) {
    _authRepository.signOut();
    Routes.openSplashScreen(context);
  }
}
