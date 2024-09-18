import 'package:dartz/dartz.dart';

import '../../../../core/error/faliure.dart';
import '../entity/user_entity.dart';
import '../repository/user_repository.dart';

class SigninUsecase{
  final UserRepository userRepository;

  SigninUsecase({
    required this.userRepository
  });

  Future<Either<Failure,UserEntity>> excute(UserEntity user)  async{
    return userRepository.signIn(user);
  }
}