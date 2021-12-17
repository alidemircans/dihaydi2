import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/brand.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/model.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/firebase_database_repository.dart';
import 'package:uydu/repository/storage_repository.dart';
import 'package:uydu/repository/user_database_repository.dart';
import 'package:uydu/widgets/loading_dialog.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uydu/widgets/translataion_widget.dart';

enum BrandState { Loading, Idle }
enum ModelState { Loading, Idle }

class SendRequestToArtisanViewModel extends ChangeNotifier {
  AuthRepository _authRepository = locator<AuthRepository>();
  StorageRepository _storageRepository = locator<StorageRepository>();
  UserDatabaseRepository _userDatabaseRepository =
      locator<UserDatabaseRepository>();

  FirebaseDatabaseRepository _firebaseDatabaseRepository =
      locator<FirebaseDatabaseRepository>();

  BrandState brandState = BrandState.Idle;
  ModelState modelState = ModelState.Idle;

  SendRequestToArtisanViewModel(CategoryModel? categoryModel, User? user) {
    if (categoryModel != null && user != null) {
      incomingUser = user;
      inComingCategoryModel = categoryModel;
     // getAllBrands(categoryModel.id);
    }
  }

  CategoryModel? inComingCategoryModel;

  DateTime? _whenArtisanWillBeComeDate;
  BrandModel? selecetedBrand;
  ModelModel? selecetedModel;
  String? _description;
  User? incomingUser;

  get description => _description;

  set descriptionSet(val) {
    _description = val;
    notifyListeners();
  }

  get whenArtisanWillBeComeDate => _whenArtisanWillBeComeDate;

  set whenArtisanWillBeComeDateSet(val) {
    _whenArtisanWillBeComeDate = val;
    notifyListeners();
  }

  List<BrandModel?> brands = [];
  List<ModelModel?> models = [];

  double? price;
  int? rate;

  getAllBrands(String? categoryId) async {
    print("Getirilecek olan id $categoryId");
    brandState = BrandState.Loading;
    notifyListeners();
    try {
      brands =
          await _firebaseDatabaseRepository.getAllBrandByCategoryId(categoryId);
      brandState = BrandState.Idle;
      print("Markalar geldi ${brands.length}");
      notifyListeners();
    } catch (e) {
      print("SendRequestToArtisanViewModel / getAllBrands $e");
      brandState = BrandState.Idle;
    }
  }

  getAllModels(String? brandId) async {
    modelState = ModelState.Loading;
    notifyListeners();
    try {
      models = await _firebaseDatabaseRepository.getAllModelsByBrandId(brandId);
      modelState = ModelState.Idle;
      print("Markalar geldi ${brands.length}");
      notifyListeners();
    } catch (e) {
      print("SendRequestToArtisanViewModel / getAllModels $e");
      modelState = ModelState.Idle;
    }
  }

  onChoseABrandPressed(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: brands.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                selecetedBrand = brands[index]!;
                await getAllModels(selecetedBrand!.id);
                notifyListeners();
                Navigator.pop(context);
              },
              child: ListTile(
                title: TextStyleGenerator(
                  text: brands[index]!.name,
                  color: Colors.black,
                ),
              ),
            );
          },
        );
      },
    );
  }

  onChoseAModelPressed(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: models.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                selecetedModel = models[index]!;

                notifyListeners();
                Navigator.pop(context);
              },
              child: ListTile(
                title: TextStyleGenerator(
                  text: models[index]!.name,
                  color: Colors.black,
                ),
              ),
            );
          },
        );
      },
    );
  }

  onNullBrandPressed(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextStyleGenerator(
            text: "Hata",
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextStyleGenerator(
              text: "Model seçmeden önce marka seçmelisin!",
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextStyleGenerator(
                  text: "Tamam",
                ),
              ),
            )
          ],
        );
      },
    );
  }

  onEmptyBrandPressed(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextStyleGenerator(
            text: "Bir Sorun Oluştu",
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextStyleGenerator(
              text: "Bu Kategoriye ait bir marka yok ",
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextStyleGenerator(
                  text: "Tamam",
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<bool> changeToEstimateDate(context, requestId) async {
    bool isEverythingOk = true;
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: TextStyleGenerator(
                  text: "Ustanın geliş tarihini değiştir",
                ),
                content: GestureDetector(
                  onTap: () {
                    var now = DateTime.now();
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: now,
                        maxTime: DateTime(now.year, now.month, now.day + 5),
                        onChanged: (date) {
                      setState(() {
                        _whenArtisanWillBeComeDate = date;
                      });
                    }, onConfirm: (date) {
                      setState(() {
                        _whenArtisanWillBeComeDate = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.tr);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: context.getDynmaicWidth(1),
                    height: context.getDynmaicHeight(.1),
                    color: Colors.white,
                    child: Center(
                      child: TextStyleGenerator(
                        text: _whenArtisanWillBeComeDate == null
                            ? "Usta ne zaman gelsin?"
                            : _whenArtisanWillBeComeDate
                                .toString()
                                .substring(0, 11),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () async {
                      print(
                          "YENİ TARİG " + whenArtisanWillBeComeDate.toString());
                      bool isOk = await _firebaseDatabaseRepository
                          .changeToEstimateDate(
                              whenArtisanWillBeComeDate, requestId);
                      Navigator.pop(context);
                      if (isOk) {
                        SnackBar snackBar = SnackBar(
                          content: TextStyleGenerator(
                            text: "Tarih başarı ile değiştirildi",
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: Colors.green,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        isEverythingOk = false;

                        SnackBar snackBar = SnackBar(
                          content: TextStyleGenerator(
                            text: "Bir sorun oluştur",
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: Colors.redAccent,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextStyleGenerator(
                        text: "Değiştir",
                      ),
                    ),
                  )
                ],
              );
            },
          );
        });
    return isEverythingOk;
  }

  Future<bool> rateArtisan(context, requestId) async {
    bool isEverythingOk = true;
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: TextStyleGenerator(
                  text: "İşi Puanla",
                ),
                content: Container(
                  margin: EdgeInsets.all(10),
                  width: context.getDynmaicWidth(1),
                  height: context.getDynmaicHeight(.2),
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          margin: EdgeInsets.zero,
                          child: Container(
                            width: context.getDynmaicWidth(1),
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (val) {
                                price = double.parse(val);
                              },
                              decoration: InputDecoration(
                                hintText: "İşin Ücreti",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: context.getDynmaicWidth(1),
                          child: Center(
                            child: RatingBar.builder(
                              initialRating: 0,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 0.0),
                              glowColor: Colors.yellow,
                              unratedColor: Colors.grey.withOpacity(.3),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                rate = rating.toInt();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () async {
                      print("PRİCE " + price.toString());
                      print("Rate " + rate.toString());

                      bool isOk = await _firebaseDatabaseRepository.rateJob(
                          requestId, price, rate);
                      Navigator.pop(context);

                      if (isOk) {
                        SnackBar snackBar = SnackBar(
                          content: TextStyleGenerator(
                            text: "Puanlama başarılı",
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: Colors.green,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        isEverythingOk = false;

                        SnackBar snackBar = SnackBar(
                          content: TextStyleGenerator(
                            text: "Bir sorun oluştur",
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: Colors.redAccent,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextStyleGenerator(
                        text: "Puanla",
                      ),
                    ),
                  )
                ],
              );
            },
          );
        });
    return isEverythingOk;
  }

  sendNewRequest(
    context,
    CategoryModel category,
    BrandModel brand,
    ModelModel model,
    String? description,
    User? user,
    DateTime time,
  ) async {
    String? userId = await _authRepository.getCurrentUserId();

    if (userId != null) {
      User? user = await _userDatabaseRepository.getUser(userId);

      LoadingDialog dialog = LoadingDialog(
        loadingText: 'İstek Oluşturuluyor..',
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return dialog;
        },
      );
      bool isAdded = await _firebaseDatabaseRepository.sendRequestToArtisan(
          category, brand, model, description!, user, time);
      if (isAdded) {
        dialog.cancel(context);
        print("Eklendi..");
        Routes.openAllRequestesPage(context, true, user, false);
      } else {
        dialog.cancel(context);
        print("Eklenirken sorun oluştu..");
      }
    }
  }
}
