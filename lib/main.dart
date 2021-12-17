import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uydu/helper/locator.dart';
import 'package:uydu/splash_screen.dart';
import 'package:uydu/view_model/language_view_model.dart';
import 'package:uydu/view_model/splash_screen_view_model.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:uydu/view_model/translate_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  setupLocator();
  await Firebase.initializeApp();
  runApp( MyApp());
}

var devicesLang;

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final languageController = Get.put(LanguageController());

  void setLocale(Locale locale) {
    setState(() {
      languageController.locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  Future<void> initPlatformState() async {
    String currentLocale;

    try {
      if (languageController.choosedLang == null) {
        currentLocale = (await Devicelocale.currentLocale)!;
        print(currentLocale);
        if (currentLocale == 'en_GB') {
          setState(() {
            devicesLang = 'en';
            languageController.setLocales(devicesLang, context);
            print('DEVİCE LANG => ' + devicesLang);
          });
        }
        if (currentLocale == 'tr_TR') {
          setState(() {
            devicesLang = 'tr';
            languageController.setLocales(devicesLang, context);
            print('DEVİCE LANG => ' + devicesLang);
          });
        }
        if (currentLocale == 'ru_RU') {
          setState(() {
            devicesLang = 'ru';
            languageController.setLocales(devicesLang, context);
            print('DEVİCE LANG => ' + devicesLang);
          });
        }
      }
    } on PlatformException {
      print("Error obtaining current locale");
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uydu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => SplashViewModel(),
        child: SplashPage(),
      ),
    );
  }
}
