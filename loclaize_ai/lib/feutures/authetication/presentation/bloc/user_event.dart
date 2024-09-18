
import 'package:loclaize_ai/feutures/authetication/domain/entity/user_entity.dart';

class UserEvent {}

class SignInEvent extends UserEvent {
  final UserEntity user;
  SignInEvent({required this.user});
}

class SignUpEvent extends UserEvent {
  final UserEntity user;
  SignUpEvent({required this.user});
}

class LogOutEvent extends UserEvent {}

