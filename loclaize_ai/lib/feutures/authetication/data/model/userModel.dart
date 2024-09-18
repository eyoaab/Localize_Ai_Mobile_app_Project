import 'package:loclaize_ai/feutures/authetication/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  String name;
  String username;
  String password;

  UserModel({
    required this.name,
    required this.username,
    required this.password,
  }) : super(name: name, username: username, password: password);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'password': password,
    };
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      username: json['username'],
      password: json['password'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      username: username,
      password: password,
    );
  }
}
