import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class ColorOptionTile extends StatefulWidget {
  final FlexScheme scheme;
  const ColorOptionTile({Key? key, required this.scheme}) : super(key: key);

  @override
  State<ColorOptionTile> createState() => _ColorOptionTileState();
}

class _ColorOptionTileState extends State<ColorOptionTile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              Container(),
              Container(),
            ],
          ),
          Row(
            children: [
              Container(),
              Container(),
            ],
          )
        ],
      ),
    );
  }
}
