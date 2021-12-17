import 'package:uydu/base/firebase_database_base.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/model/brand.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/customer_request_model.dart';
import 'package:uydu/model/model.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/service/base/firebase_database_base_service.dart';
import 'package:uydu/service/firebase_database_service.dart';

class FirebaseDatabaseRepository implements FirebaseDatabaseBase {
  FirebaseDatabaseBaseService _service = locator<FirebaseDatabaseService>();

  @override
  Future<List<CategoryModel?>> getAllCategories() async {
    return await _service.getAllCategories();
  }
  @override
  Future<List<CategoryModel?>> getFilteredCategories(List<dynamic> ids)async {
    return await _service.getFilteredCategories(ids);
  }
  @override
  Future<List<BrandModel?>> getAllBrandByCategoryId(String? categoryId) async {
    return await _service.getAllBrandByCategoryId(categoryId);
  }

  @override
  Future<bool> sendRequestToArtisan(
      CategoryModel? category,
      BrandModel? brand,
      ModelModel? model,
      String description,
      User? customer,
      DateTime? time) async {
    return await _service.sendRequestToArtisan(
        category, brand, model, description, customer, time);
  }

  @override
  Future<List<CustomerRequestModel?>> getAllRequestByUser(
      String? userId) async {
    return await _service.getAllRequestByUser(userId);
  }

  @override
  Future<List<CustomerRequestModel?>> getAllJobByArtisanId(
      String? artisanId) async {
    return await _service.getAllJobByArtisanId(artisanId);
  }

  @override
  Future<List<ModelModel?>> getAllModelsByBrandId(String? brandId) async {
    return await _service.getAllModelsByBrandId(brandId);
  }

  @override
  Future<List<String?>> getAllSliderImages() async {
    return await _service.getAllSliderImages();
  }

  @override
  Future<bool> finishJob(String? requestId, int status, String paymnetMethod,
      double price, String description) async {
    return await _service.finishJob(
        requestId, status, paymnetMethod, price, description);
  }

  @override
  Future<bool> cancelRequest(String? requestId) async {
    return await _service.cancelRequest(requestId);
  }

  @override
  Future<bool> changeToEstimateDate(
      DateTime? newDate, String? requestId) async {
    return await _service.changeToEstimateDate(newDate, requestId);
  }

  @override
  Future<bool> goToCustomer(String? requestId) async {
    return await _service.goToCustomer(requestId);
  }

  @override
  Future<bool> rateJob(String? requestId, price, point) async{
   return await _service.rateJob(requestId, price, point);
  }

  @override
  Future<List<User?>> getAllArtisan()async {
    return await _service.getAllArtisan();
    
  }


}
