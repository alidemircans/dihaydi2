import 'dart:io';

import 'package:flutter/material.dart';

class FileImageReviewPage extends StatelessWidget {
  File file;
  Function onTap;
  FileImageReviewPage({required this.file, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          InkWell(
            onTap: () {
              onTap();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: Center(
        child: Image.file(file),
      ),
    );
  }
}
