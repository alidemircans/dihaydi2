import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeInputTextFieldBasic extends StatelessWidget {
  final int length;
  final Color? inputBackgroundColor;
  final Color? inputTextColor;
  final void Function(String)? onCompleted;
  final FocusNode focusNode;
  CodeInputTextFieldBasic({
    required this.length,
    required this.focusNode,
    this.inputBackgroundColor,
    this.inputTextColor,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: inputBackgroundColor,
      shape: StadiumBorder(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 24,
            color: inputTextColor,
            fontWeight: FontWeight.bold,
          ),
          maxLength: length,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            counterText: "",
          ),
          onChanged: (String value) {
            if (value.trim().length == length) {
              onCompleted?.call(value);
            }
          },
        ),
      ),
    );
  }
}
