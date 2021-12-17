import 'package:get/get.dart';
import 'package:translator/translator.dart';
import 'package:uydu/view_model/language_view_model.dart';

enum TranslateState { Loading, Idle, Error }

class TranslateViewModel extends GetxController {
  final translator = GoogleTranslator();
  LanguageController languageController = Get.find();

  // page texts
  getText() async {
    translateState = TranslateState.Loading;
    try {
      print("language code ${languageController.choosedLang}");

      title = await translator.translate("UYDU",
          to: languageController.choosedLang);
      translateState = TranslateState.Idle;

      update();
    } catch (e) {
      translateState = TranslateState.Error;

      print("CustomerHomeViewModel / getText $e");
    }
  }

  Future<String> translate(String translateText) async {
    var translatedText;
    try {
      translatedText = await translator.translate(translateText,
          to: languageController.choosedLang);
      print(" Code ${languageController.choosedLang}");
      print(" Text $translateText");
    } catch (e) {
      print(
          "Translate View Model / Problem during translate $translateText/ $e  ");
    }
    return translatedText;
  }

  var title;

  TranslateState translateState = TranslateState.Idle;

  TranslateViewModel() {
    getText();
  }
}
