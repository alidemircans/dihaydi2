class CategoryModel {
  static const String nameKey = 'name';
  static const String priceKey = 'price';

  late String name;
  late int price;
  var id;

  CategoryModel(this.name, this.price);

  Map<String, dynamic> toMap() {
    return {nameKey: this.name, priceKey: this.price};
  }

  CategoryModel.fromMap(var dataId, Map<String, dynamic> map) {
    this.id = dataId;
    this.name = map[nameKey];
    this.price = map[priceKey];
  }
}
