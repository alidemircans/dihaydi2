import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final String? loadingText;
  final bool? isOk;

  ResultDialog({
    required this.loadingText,
    required this.isOk,
  });

  cancel(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: <Widget>[
          isOk! ?
          Icon(
            Icons.check,
            color: Colors.green,
          ): Icon(
            Icons.cancel,
            color: Colors.red,
          ),
          SizedBox(width: 15),
          Flexible(child: Text(loadingText ?? "")),
        ],
      ),
    );
  }
}
