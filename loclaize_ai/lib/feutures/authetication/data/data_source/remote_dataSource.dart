import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loclaize_ai/core/error/exception.dart';
import 'package:loclaize_ai/feutures/authetication/data/model/userModel.dart';
import 'package:loclaize_ai/feutures/authetication/domain/entity/user_entity.dart';

abstract class RemoteDatasource {
  Future<bool> signUpUser(UserEntity user);
  Future<UserModel> signInUser(UserEntity user);
}

class RemoteDatasourceImpl extends RemoteDatasource {
  final http.Client client;
  RemoteDatasourceImpl({required this.client});

  @override
  Future<bool> signUpUser(UserEntity user) async {
    try {
      await Future.delayed(const Duration(seconds: 5));
      // final response = await client.post(
      //   Uri.parse('endpoints'),
      //   body: json.encode({
      //     'name': user.name,
      //     'email': user.username,
      //     'password': user.password,
      //   }),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      // );

      // if (response.statusCode == 201) {
     
       if (201 == 201) {

        return true;
      } else {
        return false; 
      }
     
    } catch (e) {
      
      throw ServerException(); 
    }
  }

  @override
  Future<UserModel> signInUser(UserEntity user) async {
    try {
      await Future.delayed(const Duration(seconds: 5));

      // final response = await client.post(
      //   Uri.parse('endpoints'),
      //   body: json.encode({
      //     'username': user.username,
      //     'password': user.password,
      //   }),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      // );

      // if (response.statusCode == 200) {
      if (200 == 200) {

        // final responseBody = response.body;
        String jsonString = '''
                {
                  "name": "Eyob Tariku",
                  "username": "123456",
                  "password": "123456"
                }
                ''';
        // final userData = UserModel.fromJson(json.decode(responseBody));
        final userData = UserModel.fromJson(json.decode(jsonString));

        return userData;
      } else {
        throw ServerException(); 
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
