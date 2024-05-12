import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imagePath;
  final String imageCaption;

  const ImageCard({
    required this.imagePath,
    required this.imageCaption,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      //  elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300, // Set desired image height
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              //    color: Colors.black.withOpacity(0.6),
              child: Text(
                imageCaption,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
