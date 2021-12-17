import 'package:flutter/material.dart';
import 'package:uydu/helper/color_helper.dart';

class LoadingDialog extends StatelessWidget {
  final String? loadingText;

  LoadingDialog({
    required this.loadingText,
  });

  cancel(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorHelper.accentColor),
          ),
          SizedBox(width: 15),
          Flexible(child: Text(loadingText ?? "")),
        ],
      ),
    );
  }
}
