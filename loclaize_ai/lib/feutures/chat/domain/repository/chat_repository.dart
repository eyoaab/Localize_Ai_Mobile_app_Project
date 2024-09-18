import 'package:dartz/dartz.dart';
import 'package:loclaize_ai/core/error/faliure.dart';
import 'package:loclaize_ai/feutures/chat/domain/entity/chat_entity.dart';

abstract class ChatRepository{
  Future<Either<Failure, ChatEntity>> getMessage(String message) ;
} 