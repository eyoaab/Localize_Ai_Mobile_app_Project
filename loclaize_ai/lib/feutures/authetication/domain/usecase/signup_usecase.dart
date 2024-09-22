import 'package:dartz/dartz.dart';

import '../../../../core/error/faliure.dart';
import '../entity/user_entity.dart';
import '../repository/user_repository.dart';

class SignupUsecase{
  final UserRepository userRepository;

  SignupUsecase(
    {
      required this.userRepository
    }
  );

  Future<Either<Failure,String>> excute(UserEntity user)async{
    return userRepository.signUp(user);
  }
}