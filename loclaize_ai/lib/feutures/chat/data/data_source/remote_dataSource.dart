import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loclaize_ai/core/error/exception.dart';
import 'package:loclaize_ai/feutures/chat/data/model/chat_model.dart';


abstract class ChatRemoteDatasource {
  Future<ChatModel> getMessage(String message);

}

class ChatRemoteDatasourceImpl extends ChatRemoteDatasource {
  final http.Client client;
  ChatRemoteDatasourceImpl({required this.client});

  
  @override
  Future<ChatModel> getMessage(String message) async {
    try {
      final response = await client.post(
        Uri.parse('api end point'),
        body: json.encode({
          'text': message,
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = response.body;
        return ChatModel.fromJson(json.decode(responseBody));
      } else {
        throw ServerException();
      }
    } on Exception catch (e) {
      throw ServerException();
    }
    
  }
}