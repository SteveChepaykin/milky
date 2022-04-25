import 'package:flutter/material.dart';
import 'package:milky/models/search_listtile_model.dart';

class ChooseUserListtile extends StatefulWidget {
  final SearchListTile slt;
  const ChooseUserListtile({Key? key, required this.slt}) : super(key: key);

  @override
  State<ChooseUserListtile> createState() => _ChooseUserListtileState();
}

class _ChooseUserListtileState extends State<ChooseUserListtile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: (widget.slt.isChosen),
      onChanged: (v) {
        widget.slt.togglechoose(v!);
        setState(() {});
      },
      title: Text(widget.slt.user.nickname),
      subtitle: Text(widget.slt.user.identifier),
    );
  }
}
