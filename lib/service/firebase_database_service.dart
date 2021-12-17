import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uydu/model/brand.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/customer_request_model.dart';
import 'package:uydu/model/model.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/service/base/firebase_database_base_service.dart';

class FirebaseDatabaseService implements FirebaseDatabaseBaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _categoriesCollectionName = "categories";
  final String _userCollectionName = "users";

  @override
  Future<List<CategoryModel?>> getAllCategories() async {
    List<CategoryModel?> categories = [];
    QuerySnapshot qs =
        await _firestore.collection(_categoriesCollectionName).get();

    for (DocumentSnapshot data in qs.docs) {
      categories.add(getCategoryFromDeocumentSnapshot(data));
    }
    return categories;
  }

  @override
  Future<List<CategoryModel?>> getFilteredCategories(List<dynamic> ids) async {
    List<CategoryModel?> categories = [];

    for (var x in ids) {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(_categoriesCollectionName).doc(x).get();
      categories.add(getCategoryFromDeocumentSnapshot(documentSnapshot));
    }

    return categories;
  }

  @override
  Future<List<User?>> getAllArtisan() async {
    List<User?> artisans = [];
    QuerySnapshot qs = await _firestore.collection(_userCollectionName).get();

    for (DocumentSnapshot data in qs.docs) {
      artisans.add(getUserFromDocumentSnapshot(data));
    }
    return artisans;
  }

  @override
  Future<List<BrandModel?>> getAllBrandByCategoryId(String? categoryId) async {
    List<BrandModel?> brands = [];
    /* QuerySnapshot qs = await _firestore
        .collection(_brandsCollectionName)
        .where(BrandModel.categoryIdKey, isEqualTo: categoryId)
        .get();

    for (DocumentSnapshot data in qs.docs) {
      BrandModel? brand = getBrandFromDocumentSnapshot(data);
      brands.add(brand);
    }*/
    return brands;
  }

  @override
  Future<bool> sendRequestToArtisan(
      CategoryModel? category,
      BrandModel? brand,
      ModelModel? incomingModel,
      String description,
      User? customer,
      time) async {
    bool isAdded = true;
/*
    Map<String, dynamic> model = CustomerRequestModel(
      categoryName: category!.name,
      brandName: brand!.name,
      modelName: incomingModel!.name,
      artisanId: "",
      decriptionByCustomer: description,
      decriptionByArtisan: "",
      customerId: customer!.userId,
      customerName: customer.displayName,
      artisanName: "",
    ).toMap();
    model[CustomerRequestModel.priceByArtisanKey] = 0;
    model[CustomerRequestModel.priceByCustomerKey] = 0;
    model[CustomerRequestModel.customerPhoneKey] = customer.phone;
    model[CustomerRequestModel.sentAtKey] = FieldValue.serverTimestamp();
    model[CustomerRequestModel.comeDateKey] = time;
    model[CustomerRequestModel.statusKey] = 4;
    model[CustomerRequestModel.paymentMethodKey] = "";

    try {
      await _firestore.collection(_requestsCollectionName).add(model);
    } catch (e) {
      print("FirebaseDatabaseService / sendRequestToArtisan $e");
      isAdded = false;
    }*/
    return isAdded;
  }

  @override
  Future<List<CustomerRequestModel?>> getAllRequestByUser(
      String? userId) async {
    List<CustomerRequestModel?> requests = [];
    /* QuerySnapshot qs = await _firestore
        .collection(_requestsCollectionName)
        .where(CustomerRequestModel.customerIdKey, isEqualTo: userId)
        .orderBy(CustomerRequestModel.sentAtKey, descending: true)
        .get();

    for (DocumentSnapshot data in qs.docs) {
      CustomerRequestModel? reques =
          getCustomerRequestModelFromDocumentSnapshot(data);
      requests.add(reques);
    }*/
    return requests;
  }

  @override
  Future<List<CustomerRequestModel?>> getAllJobByArtisanId(
      String? artisanId) async {
    List<CustomerRequestModel?> requests = [];
    /*  QuerySnapshot qs = await _firestore
        .collection(_requestsCollectionName)
        .where(CustomerRequestModel.artisanIdKey, isEqualTo: artisanId)
        .orderBy(CustomerRequestModel.statusKey, descending: true)
        .get();

    for (DocumentSnapshot data in qs.docs) {
      CustomerRequestModel? reques =
          getCustomerRequestModelFromDocumentSnapshot(data);
      requests.add(reques);
    }*/
    return requests;
  }

  @override
  Future<List<ModelModel?>> getAllModelsByBrandId(String? brandId) async {
    List<ModelModel?> models = [];
    /* QuerySnapshot qs = await _firestore
        .collection(_modelsCollectionName)
        .where(ModelModel.brandIdKey, isEqualTo: brandId)
        .get();

    for (DocumentSnapshot data in qs.docs) {
      ModelModel? model = getModelFromDocumentSnapshot(data);
      models.add(model);
    }*/
    return models;
  }

  @override
  Future<List<String?>> getAllSliderImages() async {
    List<String?>? images = [];
/*
    try {
      QuerySnapshot qs =
          await _firestore.collection(_slidersCollectionName).get();

      for (DocumentSnapshot data in qs.docs) {
        images.add(data.data()!["imageUrl"]);
      }
    } catch (e) {
      print("FirebaseDatabaseService / getAllSliderImages $e");
    }*/
    return images;
  }

  @override
  Future<bool> finishJob(String? requestId, int status, String paymnetMethod,
      double price, String description) async {
    bool result = true;
/*
    try {
      await _firestore
          .collection(_requestsCollectionName)
          .doc(requestId)
          .update({
        CustomerRequestModel.statusKey: status,
        CustomerRequestModel.priceByArtisanKey: status == 0 ? price : 0,
        CustomerRequestModel.paymentMethodKey: status == 0 ? paymnetMethod : "",
        CustomerRequestModel.decriptionByArtisanKey: description,
      });
    } catch (e) {
      result = false;
      print('FirestoreUserDatabaseService / updateUser : ${e.toString()}');
    }*/

    return result;
  }

  @override
  Future<bool> cancelRequest(String? requestId) async {
    bool result = true;
/*
    try {
      await _firestore
          .collection(_requestsCollectionName)
          .doc(requestId)
          .update({
        CustomerRequestModel.statusKey: 3,
      });
    } catch (e) {
      result = false;
      print('FirestoreUserDatabaseService / updateUser : ${e.toString()}');
    }*/

    return result;
  }

  @override
  Future<bool> changeToEstimateDate(
      DateTime? newDate, String? requestId) async {
    bool result = true;
/*
    try {
      await _firestore
          .collection(_requestsCollectionName)
          .doc(requestId)
          .update({CustomerRequestModel.comeDateKey: newDate});
    } catch (e) {
      result = false;
      print(
          'FirestoreUserDatabaseService / changeToEstimateDate : ${e.toString()}');
    }
*/
    return result;
  }

  @override
  Future<bool> goToCustomer(String? requestId) async {
    bool result = true;
/*
    try {
      await _firestore
          .collection(_requestsCollectionName)
          .doc(requestId)
          .update({
        CustomerRequestModel.statusKey: 5,
      });
    } catch (e) {
      result = false;
      print('FirestoreUserDatabaseService / goToCustomer : ${e.toString()}');
    }
*/
    return result;
  }

  @override
  Future<bool> rateJob(String? requestId, price, point) async {
    bool result = true;
/*
    try {
      await _firestore
          .collection(_requestsCollectionName)
          .doc(requestId)
          .update({
        CustomerRequestModel.pointKey: point,
        CustomerRequestModel.priceByCustomerKey: price,
      });
    } catch (e) {
      result = false;
      print('FirestoreUserDatabaseService / rateJob : ${e.toString()}');
    }
*/
    return result;
  }

  CategoryModel? getCategoryFromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic>? categoryMap = doc.data();
    if (categoryMap != null) {
      // return CategoryModel.fromMap(doc.id, categoryMap);
    }
    return null;
  }

  BrandModel? getBrandFromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic>? brandMap = doc.data();
    if (brandMap != null) {
      return BrandModel.fromMap(doc.id, brandMap);
    }
    return null;
  }

  User? getUserFromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic>? userMap = doc.data();
    if (userMap != null) {
      userMap[User.sentAtKey] = (userMap[User.sentAtKey] as Timestamp).toDate();
      return User.fromMap(doc.id, userMap);
    }
    return null;
  }

  ModelModel? getModelFromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic>? modelMap = doc.data();
    if (modelMap != null) {
      return ModelModel.fromMap(doc.id, modelMap);
    }
    return null;
  }

  CategoryModel? getCategoryFromDeocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic>? categoryMap = doc.data();
    if (categoryMap != null) {
      return CategoryModel.fromMap(doc.id, categoryMap);
    }
    return null;
  }

  CustomerRequestModel? getCustomerRequestModelFromDocumentSnapshot(
      DocumentSnapshot doc) {
    Map<String, dynamic>? requestMap = doc.data();
    if (requestMap != null) {
      requestMap[CustomerRequestModel.sentAtKey] =
          (requestMap[CustomerRequestModel.sentAtKey] as Timestamp).toDate();
      requestMap[CustomerRequestModel.comeDateKey] =
          (requestMap[CustomerRequestModel.comeDateKey] as Timestamp).toDate();
      return CustomerRequestModel.fromMap(doc.id, requestMap);
    }
    return null;
  }
}
