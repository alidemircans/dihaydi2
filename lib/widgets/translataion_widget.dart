import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uydu/service/transation_api.dart';
import 'package:uydu/view_model/language_view_model.dart';
import 'package:uydu/widgets/text_generator.dart';

class TranslationWidget extends StatefulWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLine;
  final overflow;
  final TextAlign? alignment;

  TranslationWidget({
    @required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.maxLine,
    this.overflow,
    this.alignment,
  });

  @override
  _TranslationWidgetState createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  String? translation;

  @override
  Widget build(BuildContext context) {
    LanguageController languageController = Get.find();

    return FutureBuilder(
      future: TranslationApi.translate(
         widget.text!, languageController.choosedLang),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return buildWaiting();
          default:
            if (snapshot.hasError) {
              print("error ${snapshot.error}");
              translation = snapshot.error.toString();
            } else {
              translation = snapshot.data.toString();
            }
            return TextStyleGenerator(
              color: widget.color,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              maxLine: widget.maxLine,
              overflow: widget.overflow,
              alignment: widget.alignment,
              text: translation.toString(),
            );
        }
      },
    );
  }

  Widget buildWaiting() => translation == null
      ? Container(
          child: TextStyleGenerator(
            text: "...",
          ),
        )
      : TextStyleGenerator(
          color: widget.color,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          maxLine: widget.maxLine,
          overflow: widget.overflow,
          alignment: widget.alignment,
          text: translation,
        );
}
