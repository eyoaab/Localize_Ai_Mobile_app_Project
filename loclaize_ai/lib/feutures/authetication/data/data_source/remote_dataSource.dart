import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loclaize_ai/core/error/exception.dart';
import 'package:loclaize_ai/feutures/authetication/data/model/model.dart';
import 'package:loclaize_ai/feutures/authetication/data/model/userModel.dart';
import 'package:loclaize_ai/feutures/authetication/domain/entity/user_entity.dart';

abstract class RemoteDatasource {
  Future<String> signUpUser(UserEntity user);
  Future<Model> signInUser(UserEntity user);
}

class RemoteDatasourceImpl extends RemoteDatasource {
  final http.Client client;
  RemoteDatasourceImpl({required this.client});

  @override
  Future<String> signUpUser(UserEntity user) async {
    try {
      final response = await client.post(
        Uri.parse('https://backend-iftf.onrender.com/register'),
        body: json.encode({
          'name': user.name,
          'username': user.username,
          'password': user.password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final responseBody = response.body;
        
        final message = jsonDecode(responseBody)["message"];
     

        return message;
      } else if (response.statusCode == 400){
        
        final responseBody = response.body;
        
        final message = jsonDecode(responseBody)["error"];
     

        return message;
      }else{
        return "Registration failed";
      }
     
    } catch (e) {
      
      throw ServerException(); 
    }
  }

  @override
  Future<Model> signInUser(UserEntity user) async {
    try {
      await Future.delayed(const Duration(seconds: 5));

      final response = await client.post(
        Uri.parse('https://backend-iftf.onrender.com/login'),
        body: json.encode({
          'username': user.username,
          'password': user.password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        final responseBody = response.body;
     
        final model = Model.fromJson(json.decode(responseBody));

        return model;
      } else {
        final responseBody = response.body;

        final badResponse =  Model(name: '', username: '', token: '', isError: true, 
        message: json.decode(responseBody)["error"]);
        return badResponse;

      }
    } catch (e) {
      throw ServerException();
    }
  }
}
