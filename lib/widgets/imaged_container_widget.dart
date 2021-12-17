import 'package:flutter/material.dart';

class ImagedContainerGeneratorWidget extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;
  final Color borderColor;
  final double borerRadiusWidth;
  final bool isNetworkImage;

  const ImagedContainerGeneratorWidget({
    required this.height,
    required this.width,
    required this.imageUrl,
    required this.borderColor,
    required this.borerRadiusWidth,
    required this.isNetworkImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: borerRadiusWidth,
        ),
        shape: BoxShape.circle,
        image: isNetworkImage
            ? DecorationImage(
                image: NetworkImage(
                  imageUrl.toString(),
                ),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: AssetImage(
                  imageUrl.toString(),
                ),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
