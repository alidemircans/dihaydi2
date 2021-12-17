class User {
  static const String userIdKey = 'userId';
  static const String emailKey = 'email';
  static const String displayNameKey = 'displayName';
  static const String photoUrlKey = 'photoUrl';
  static const String deviceTokenKey = 'token';
  static const String isArtisanKey = 'isArtisan';
  static const String phoneKey = 'phone';
  static const String adressKey = 'adress';
  static const String categoriesKey = 'categories';
  static const String isAdminKey = 'isAdmin';
  static const String sentAtKey = 'sentAt';
  static const String latKey = 'lat';
  static const String longKey = 'long';

  static const String userDefaultProfileImage =
      "https://firebasestorage.googleapis.com/v0/b/wingding-78278.appspot.com/o/app_assets%2Fprofile_photo_placeholder.png?alt=media&token=7944bf5c-d288-4c20-98fd-efd4fc6b67df";

  late String userId;
  late String email;
  late bool isArtisan;
  bool? isAdmin;
  DateTime? sentAt;
  String? displayName;
  String? photoUrl;
  String? phone;
  String? adress;
  String? token;
  String? lat;
  String? long;

  List<dynamic>? categories;

  String? errorMessage;

  User(this.userId, this.email);

  User.fromErrorMessage(this.errorMessage);

  Map<String, dynamic> toMap() {
    return {
      userIdKey: this.userId,
      emailKey: this.email,
      displayNameKey: this.displayName,
      photoUrlKey: this.photoUrl,
      isArtisanKey: this.isArtisan,
      phoneKey: this.phone,
      adressKey: this.adress,
      isAdminKey: this.isAdmin,
      sentAtKey: sentAt,
      categoriesKey: this.categories,
      latKey: this.lat,
      longKey: this.long
    };
  }

  User.fromMap(String userId, Map<String, dynamic> map) {
    this.userId = userId;
    this.email = map[emailKey];
    this.displayName = map[displayNameKey] ?? '';
    this.isArtisan = map[isArtisanKey] ?? false;
    this.photoUrl = map[photoUrlKey].length == 0
        ? userDefaultProfileImage
        : map[photoUrlKey];
    this.phone = map[phoneKey];
    this.adress = map[adressKey];
    this.isAdmin = map[isAdminKey];
    this.sentAt = map[sentAtKey];
    this.token = map[deviceTokenKey];
    this.categories = map[categoriesKey];
    this.lat = map[latKey];
    this.long = map[longKey];
  }
}
