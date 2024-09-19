import 'dart:convert';
import 'dart:developer';
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
      await Future.delayed(const Duration(seconds: 2));

      // final response = await client.post(
      //   Uri.parse('api end point'),
      //   body: json.encode({
      //     'text': message,
      //   }),
      // );
      // if (response.statusCode == 200) {
      if (200 == 200) {
        log('this from the remote data source');
        log(message);

        // final responseBody = response.body;
         String jsonString = '''
              {
                "message": "Hello Eyob the one and the only, how can I assist you today?"
              }
              ''';
        // return ChatModel.fromJson(json.decode(responseBody));
        return ChatModel.fromJson(json.decode(jsonString));

      } else {
        throw ServerException();
      }
    } on Exception catch (e) {
      throw ServerException();
    }
    
  }
}