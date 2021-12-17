import 'package:flutter/material.dart';
import 'package:uydu/helper/color_helper.dart';

class AuthTextField extends StatelessWidget {
  final String titleText;
  final String? hintText;
  final String? initialText;
  final List<String>? autofillHints;
  final TextInputType? inputType;
  final int? maxLength;
  final bool obscureText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final FocusNode? focusNode;

  AuthTextField({
    this.titleText = '',
    this.hintText,
    this.initialText,
    this.autofillHints,
    this.inputType,
    this.maxLength,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titleText.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 32, bottom: 8),
              child: Text(
                titleText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorHelper.authTextFieldTitleColor,
                ),
              ),
            ),
          Card(
            color: Colors.transparent,
            shape: StadiumBorder(),
            elevation: 8,
            child: TextFormField(
              keyboardType: inputType,
              obscureText: obscureText,
              focusNode: focusNode,
              autofocus: false,
              maxLength: maxLength,
              style: TextStyle(
                color: ColorHelper.authTextFieldHintColor,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: ColorHelper.authTextFieldHintColor,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                filled: true,
                fillColor: ColorHelper.authTextFieldFillColor,
                counterText: '',
                suffixIcon: suffixIcon,
              ),
              onChanged: onChanged,
              initialValue: initialText,
              autofillHints: autofillHints,
            ),
          ),
        ],
      ),
    );
  }
}
