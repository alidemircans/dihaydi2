import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:uydu/helper/color_helper.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Alignment childAlignment;
  final EdgeInsets childPadding;
  final void Function()? onPressed;
  final double heightButton;

  AuthButton({
    required this.label,
    this.isActive = false,
    this.activeColor = ColorHelper.chatCardPink,
    this.inactiveColor = ColorHelper.registerLoginPageBackgroundColor,
    this.activeTextColor = ColorHelper.authButtonActiveTextColor,
    this.inactiveTextColor = ColorHelper.authButtonInactiveTextColor,
    this.childAlignment = Alignment.center,
    this.childPadding = EdgeInsets.zero,
    this.onPressed,
    this.heightButton = double.minPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: heightButton.isNaN ? heightButton : 56,
      child: ElevatedButton(
        child: Padding(
          padding: childPadding,
          child: Align(
            alignment: childAlignment,
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? activeTextColor : inactiveTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: isActive ? activeColor : inactiveColor,
          shape: StadiumBorder(
            side: isActive
                ? BorderSide.none
                : BorderSide(
                    width: 3,
                    color: inactiveTextColor,
                  ),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          onPressed?.call();
        },
      ),
    );
  }
}
