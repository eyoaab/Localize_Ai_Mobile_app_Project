
import 'package:loclaize_ai/feutures/chat/domain/entity/chat_entity.dart';

abstract class ChatState {}

class ChatIdleState extends ChatState {}

class ChatLoadingState extends ChatState {}



class ChatLoadedState extends ChatState {
  final ChatEntity chatData;
  ChatLoadedState({required this.chatData});
}


class ChatErrorState extends ChatState {
   final String errorMessage;
     ChatErrorState({
    required this.errorMessage
    });
 }   



