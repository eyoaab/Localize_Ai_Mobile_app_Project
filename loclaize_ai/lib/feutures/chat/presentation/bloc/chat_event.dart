

class ChatEvent {}

class GetChatEvent extends ChatEvent {
  final String message;
  GetChatEvent({required this.message});
}



