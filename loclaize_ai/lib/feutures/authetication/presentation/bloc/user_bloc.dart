


import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loclaize_ai/core/error/faliure.dart';
import 'package:loclaize_ai/feutures/authetication/data/model/model.dart';
import 'package:loclaize_ai/feutures/authetication/domain/entity/user_entity.dart';
import 'package:loclaize_ai/feutures/authetication/domain/usecase/signin_usecase.dart';
import 'package:loclaize_ai/feutures/authetication/domain/usecase/signup_usecase.dart';


import 'user_event.dart';
import 'user_state.dart';



 
class UserBloc extends Bloc<UserEvent, UserState> {
   
  final SignupUsecase signUpUsecase;
  final SigninUsecase signInUsecase;

  UserBloc({
    required this.signUpUsecase,
    required this.signInUsecase,
  }) : super(UserInitialState()){
      

   
    
    on<SignUpEvent> ((event,emit)async{
      emit(UserLoadingState());
      final Either<Failure, String> result = await signUpUsecase.excute(event.user);
      result.fold(
        (failure) => emit(UserErrorState(errorMessage: failure.message)),
        (respomse) => emit(UserSignUpState(message: respomse)),
      );
      });

    on<SignInEvent> ((event,emit)async{
      emit(UserLoadingState());
      final Either<Failure, Model> result = await signInUsecase.excute(event.user);
      result.fold(
        (failure) => emit(UserErrorState(errorMessage: failure.message)),
        (check) { 
          // log(check.name);
          // log(check.username);
          // log(check.password);

          emit(UserLoggedInState(userData: check));},

        // (check) => emit(UserLoggedInState(userData: check)),
      );
      });
  }
  }