import 'package:loclaize_ai/feutures/authetication/domain/entity/user_entity.dart';

abstract class UserState {}

class UserInitialState extends UserState {}
class UserLoadingState extends UserState {}



class UserLoggedInState extends UserState {
  final UserEntity userData;
  UserLoggedInState({required this.userData});

}
class UserSignUpState extends UserState {
  final bool successful;
  UserSignUpState({
    required this.successful
    });
    }

class UserErrorState extends UserState {
   final String errorMessage;
     UserErrorState({
    required this.errorMessage
    });
 }   



