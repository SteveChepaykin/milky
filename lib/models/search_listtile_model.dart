import 'package:milky/models/user_model.dart';

class SearchListTile{
  final UserModel user;
  bool isChosen = false;

  SearchListTile(this.user);

  void togglechoose(bool val) {
    isChosen = val;
  }
}