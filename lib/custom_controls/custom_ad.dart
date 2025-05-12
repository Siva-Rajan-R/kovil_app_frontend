
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageShowerDialog extends StatelessWidget{
  final String imageUrl;
  const ImageShowerDialog({required this.imageUrl,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoView(
          errorBuilder: (context, error, stackTrace) {
            print("Image load error: $error");
            return const Center(
              child: SizedBox(
                height: 100,
                child: Text(
                  '⚠️ Unable to load image. Check your internet connection.',
                  style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
      
                ),
              ),
            );
          },
          imageProvider: NetworkImage(
              imageUrl,
            ),
        ),
      ),
    );
  }
}