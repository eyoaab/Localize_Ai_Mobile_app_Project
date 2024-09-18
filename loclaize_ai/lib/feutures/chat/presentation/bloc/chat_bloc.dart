import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loclaize_ai/core/error/faliure.dart';
import 'package:loclaize_ai/feutures/chat/domain/entity/chat_entity.dart';
import 'package:loclaize_ai/feutures/chat/domain/usecase/get_chat_usecase.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_event.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
   
final GetChatUsecase get_chat_usecase;

  ChatBloc({
    required this.get_chat_usecase,
  }) : super(ChatIdleState()){
     
    on<GetChatEvent> ((event,emit)async{
      emit(ChatLoadingState());
      final Either<Failure, ChatEntity> result = await get_chat_usecase.excute(event.message);
      result.fold(
        (failure) => emit(ChatErrorState(errorMessage: failure.message)),
        (check) => emit(ChatLoadedState(chatData: check)),
      );
      });

   
  }
  }