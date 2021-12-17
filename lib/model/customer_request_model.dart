class CustomerRequestModel {
  static const String categoryNameKey = 'categoryName';
  static const String brandNameKey = 'brandName';
  static const String modelNameKey = 'modelName';
  static const String decriptionByCustomerKey = 'descriptionByCustomer';
  static const String decriptionByArtisanKey = 'descriptionByArtisan';
  static const String artisanIdKey = 'artisanId';
  static const String customerIdKey = 'customerId';
  static const String statusKey = 'status';
  static const String priceByCustomerKey = 'priceByCustomer';
  static const String priceByArtisanKey = 'priceByArtisan';
  static const String paymentMethodKey = 'paymentMethod';
  static const String customerNameKey = 'customerName';
  static const String artisanNameKey = 'artisanName';
  static const String customerPhoneKey = 'customerPhone';
  static const String artisanPhoneKey = 'artisanPhone';
  static const String sentAtKey = 'sentAt';
  static const String comeDateKey = 'comeDate';
  static const String pointKey = 'point';

  late String requestId;
  late String categoryName;
  late String brandName;
  late String modelName;
  late String customerId;
  DateTime? sentAt;
  DateTime? comeDate;
  int? status;
  String? customerName;
  String? artisanName;
  String? decriptionByCustomer;
  String? decriptionByArtisan;
  String? artisanId;
  bool? isFinished;
  bool? isCanceled;
  double? point;
  int? priceByCustomer;
  int? priceByArtisan;

  String? customerPhone;
  String? artisanPhone;

  CustomerRequestModel({
    required this.categoryName,
    required this.brandName,
    required this.modelName,
    this.artisanId,
    this.decriptionByCustomer,
    this.decriptionByArtisan,
    this.isFinished,
    required this.customerId,
    this.customerName,
    this.artisanName,
  });

  Map<String, dynamic> toMap() {
    return {
      categoryNameKey: this.categoryName,
      brandNameKey: this.brandName,
      modelNameKey: this.modelName,
      decriptionByArtisanKey: this.decriptionByArtisan,
      decriptionByCustomerKey: this.decriptionByCustomer,
      artisanIdKey: "",
      customerIdKey: customerId,
      customerNameKey: customerName,
      artisanNameKey: artisanName,
      sentAtKey: sentAt,
      comeDateKey: comeDate,
      statusKey: status,
      pointKey: point,
      priceByArtisanKey: priceByArtisan,
      priceByCustomerKey: priceByCustomer,
      customerPhoneKey: customerPhone,
      artisanPhoneKey: artisanPhone,
    };
  }

  CustomerRequestModel.fromMap(requestId, Map<String, dynamic> map) {
    this.requestId = requestId;
    this.categoryName = map[categoryNameKey];
    this.brandName = map[brandNameKey];
    this.decriptionByCustomer = map[decriptionByCustomerKey];
    this.decriptionByArtisan = map[decriptionByArtisanKey];
    this.artisanId = map[artisanIdKey];
    this.status = map[statusKey];
    this.customerId = map[customerIdKey];
    this.customerName = map[customerNameKey];
    this.modelName = map[modelNameKey];
    this.artisanName = map[artisanNameKey];
    this.sentAt = map[sentAtKey];
    this.comeDate = map[comeDateKey];
    this.point = map[pointKey] == null ? null : map[pointKey].toDouble();
    this.priceByCustomer =
        map[priceByCustomerKey] == null ? 0 : map[priceByCustomerKey].toInt();
    this.priceByArtisan =
        map[priceByArtisanKey] == null ? 0 : map[priceByArtisanKey].toInt();

    this.customerPhone = map[customerPhoneKey];
    this.artisanPhone = map[artisanPhoneKey];
  }
}
