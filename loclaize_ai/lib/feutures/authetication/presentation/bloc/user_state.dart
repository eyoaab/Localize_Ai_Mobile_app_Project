import 'package:loclaize_ai/feutures/authetication/data/model/model.dart';

abstract class UserState {}

class UserInitialState extends UserState {}
class UserLoadingState extends UserState {}



class UserLoggedInState extends UserState {
  final Model userData;
  UserLoggedInState({required this.userData});

}
class UserSignUpState extends UserState {
  final String message;
  UserSignUpState({
    required this.message
    });
    }

class UserErrorState extends UserState {
   final String errorMessage;
     UserErrorState({
    required this.errorMessage
    });
 }   



