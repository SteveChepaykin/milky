import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PfpPick extends StatefulWidget {
  final Function(File? picked) pickImage;
  const PfpPick({Key? key, required this.pickImage}) : super(key: key);

  @override
  State<PfpPick> createState() => _PfpPickState();
}

class _PfpPickState extends State<PfpPick> {
  File? imagefile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          CircleAvatar(
            backgroundImage: imagefile != null ? FileImage(imagefile!) : null,
            radius: 50,
          ),
          Positioned(
            right: -15,
            top: 60,
            child: IconButton(
              onPressed: () async {
                var picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60, maxHeight: 300);
                if (picked != null) {
                  setState(() {
                    imagefile = File(picked.path);
                    widget.pickImage(imagefile!);
                  });
                } else {
                  setState(() {
                    imagefile = null;
                  });
                }
              },
              icon: const Icon(Icons.image),
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              // color:,
            ),
          ),
        ],
      ),
    );
  }
}
