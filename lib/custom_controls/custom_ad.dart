
import 'package:flutter/material.dart';

class ImageShowerDialog extends StatelessWidget{
  final String imageUrl;
  const ImageShowerDialog({required this.imageUrl,super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: InteractiveViewer(
        maxScale: 10.0,
        panEnabled: true,
        child: Expanded(
          child: Image.network(
            imageUrl,
            )
          ),
          
        ),
    );
  }
}