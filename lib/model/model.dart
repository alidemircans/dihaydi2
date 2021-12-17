class ModelModel {
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String brandIdKey = 'brandId';

  late String name;
  late String brandId;
  late String id;

  ModelModel(this.name, this.brandId);

  Map<String, dynamic> toMap() {
    return {
      nameKey: this.name,
      brandIdKey: this.brandId,
    };
  }

  ModelModel.fromMap(String? brandId, Map<String, dynamic> map) {
    this.name = map[nameKey];
    this.brandId = map[brandIdKey];
    this.id = brandId!;
  }
}
