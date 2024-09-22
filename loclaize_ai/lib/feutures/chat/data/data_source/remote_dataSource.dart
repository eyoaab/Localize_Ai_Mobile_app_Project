import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:loclaize_ai/core/error/exception.dart';
import 'package:loclaize_ai/feutures/chat/data/model/chat_model.dart';

abstract class ChatRemoteDatasource {
  Future<ChatModel> getMessage(String message, String token);
}

class ChatRemoteDatasourceImpl extends ChatRemoteDatasource {
  final http.Client client;
  ChatRemoteDatasourceImpl({required this.client});

  @override
  Future<ChatModel> getMessage(String message,String token) async {
    try {
      
      final response = await client.post(
        Uri.parse('https://backend-iftf.onrender.com/gpt'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: json.encode({
          'prompt': message,
        }),
      );

      // log("Response status: ${response.statusCode}");
      // log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return ChatModel.fromJson(json.decode(response.body));
      } else {
        // log('Server responded with status: ${response.statusCode}');
        throw ServerException();
      }
    } on Exception catch (e) {
      // log(e.toString());
      throw ServerException();
    }
  }
}
