import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  final String imageurl;
  const ImageViewScreen({Key? key, required this.imageurl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('photo'),
        // actions: [],
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: Image.network(imageurl, fit: BoxFit.fitWidth,),
          minScale: 1,
          maxScale: 4,
        ),
      ),
    );
  }
}
