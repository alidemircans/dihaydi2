import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uydu/main.dart';
import 'package:uydu/view_model/translate_view_model.dart';

class LanguageController extends GetxController {
  LanguageController() {
    getLocale();
  }

  var choosedLang = "tr";

  var languages = ['tr', 'en', 'ru'];

  var locale;
  String prefSelectedLanguageCode = "SelectedLanguageCode";

  Future<Locale> setLocales(String languageCode, context) async {
    print('buraya girdi $languageCode');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(prefSelectedLanguageCode, languageCode);
    choosedLang = languageCode;
    _restartApp(context);
    print('choosedLang atandı $choosedLang');
    Get.offAll(() => MyApp());
    update();
    return _locale(languageCode);
  }

  Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (_prefs.getString(prefSelectedLanguageCode) != null &&
        _prefs.getString(prefSelectedLanguageCode) != "") {
      String languageCode =
          _prefs.getString(prefSelectedLanguageCode) ?? devicesLang;
      choosedLang = languageCode;
      print(choosedLang + "xd");
      final translateController = Get.put(TranslateViewModel());
      update();
      return _locale(languageCode);
    } else {
      print("Kayıtlı dil yok");
      return Locale("tr", "TR");
    }
  }

  Locale _locale(String languageCode) {
    return languageCode != null && languageCode.isNotEmpty
        ? Locale(languageCode, '')
        : Locale('$devicesLang', '');
  }

  void changeLanguage(BuildContext context, String selectedLanguageCode) async {
    var _locale = await setLocales(selectedLanguageCode, context);
    MyApp.setLocale(context, _locale);
    update();
  }

  void _restartApp(context) async {
    Restart.restartApp(webOrigin: '[your main route]');
  }
}
