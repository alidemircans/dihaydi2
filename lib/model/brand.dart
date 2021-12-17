class BrandModel {
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String categoryIdKey = 'categoryId';

  late String name;
  late String categoryId;
  late String id;

  BrandModel(this.name, this.categoryId);

  Map<String, dynamic> toMap() {
    return {
      nameKey: this.name,
      categoryIdKey: this.categoryId,
    };
  }

  BrandModel.fromMap(String? brandId, Map<String, dynamic> map) {
    this.name = map[nameKey];
    this.categoryId = map[categoryIdKey];
    this.id = brandId!;
  }
}
