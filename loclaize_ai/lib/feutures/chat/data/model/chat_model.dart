import 'package:loclaize_ai/feutures/chat/domain/entity/chat_entity.dart';

class ChatModel extends ChatEntity {
  String message;

  ChatModel({
    required this.message,
  }) : super(message: message);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message, 
    };
  }

  ChatEntity toEntity() {
    return ChatEntity(
      message: message,
    );
  }
}
