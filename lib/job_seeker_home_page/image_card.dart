import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imagePath;
  final String imageCaption;

  const ImageCard({
    Key? key,
    required this.imagePath,
    required this.imageCaption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      //  elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide.none, // Ensures no border
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.fill,
        width: 300,
        height: 400, // Set desired image height
      ),
    );
  }
}
