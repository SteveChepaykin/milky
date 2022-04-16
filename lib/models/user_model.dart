class UserModel {
  final String id;
  late final String email;
  late final String nickname;
  late final String identifier;
  late final String? profilepicUrl;
  late bool isonline;
  late final String cloudtoken;

  UserModel.fromMap(this.id, Map<String, dynamic> map) {
    email = map['email'] != null ? map['email'] as String : throw 'NEED EMAIL IN USER $id';
    nickname = map['nickname'] != null ? map['nickname'] as String : throw 'NEED NICKNAME IN USER $id';
    identifier = map['identifier'] != null ? map['identifier'] as String : throw 'NEED IDENTIFIER IN USER $id';
    profilepicUrl = map['picture_url'] != null ? map['picture_url'] as String : null; 
    isonline = map['is_online'] != null ? map['is_online'] as bool : throw 'NEED STATUS IN USER $id';
    cloudtoken = map['cloud_token'] != null ? map['cloud_token'] as String : throw 'NEED TOKEN IN USER $id';
  }
}