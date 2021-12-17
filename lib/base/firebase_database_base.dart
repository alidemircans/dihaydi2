import 'package:uydu/model/brand.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/customer_request_model.dart';
import 'package:uydu/model/model.dart';
import 'package:uydu/model/user.dart';

abstract class FirebaseDatabaseBase {
  Future<List<CategoryModel?>> getAllCategories();
  Future<List<CategoryModel?>> getFilteredCategories(List<dynamic> ids);

  Future<List<User?>> getAllArtisan();
  Future<List<BrandModel?>> getAllBrandByCategoryId(String? categoryId);
  Future<List<ModelModel?>> getAllModelsByBrandId(String? brandId);
  Future<List<String?>> getAllSliderImages();
  Future<bool> sendRequestToArtisan(
    CategoryModel? category,
    BrandModel? brand,
    ModelModel? model,
    String description,
    User? customer,
    DateTime? time,
  );
  Future<bool> finishJob(String? requestId, int status, String paymnetMethod,
      double price, String description);
  Future<bool> cancelRequest(String? requestId);
  Future<List<CustomerRequestModel?>> getAllRequestByUser(String? userId);
  Future<List<CustomerRequestModel?>> getAllJobByArtisanId(String? artisanId);
  Future<bool> changeToEstimateDate(DateTime? newDate, String? requestId);
  Future<bool> goToCustomer(String? requestId);
  Future<bool> rateJob(String? requestId, price, point);
}
