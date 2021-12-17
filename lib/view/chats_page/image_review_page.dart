import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageReviewPage extends StatelessWidget {
  final String url;
  const ImageReviewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: PhotoView(
          minScale: PhotoViewComputedScale.contained ,
          maxScale: PhotoViewComputedScale.covered * 2,
          imageProvider: NetworkImage(
            url,
          ),
        ),
      ),
    );
  }
}
