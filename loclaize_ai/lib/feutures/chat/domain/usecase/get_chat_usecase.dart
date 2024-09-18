import 'package:dartz/dartz.dart';
import 'package:loclaize_ai/core/error/faliure.dart';
import 'package:loclaize_ai/feutures/chat/domain/entity/chat_entity.dart';
import 'package:loclaize_ai/feutures/chat/domain/repository/chat_repository.dart';

class GetChatUsecase{
  final ChatRepository chatRepository;

  GetChatUsecase({required this.chatRepository});

Future<Either<Failure,ChatEntity>> excute(String message) async {
    return chatRepository.getMessage(message);
}
}