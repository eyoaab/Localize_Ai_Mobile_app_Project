import 'package:dartz/dartz.dart';
import 'package:loclaize_ai/feutures/authetication/data/model/model.dart';

import '../../../../core/error/faliure.dart';
import '../entity/user_entity.dart';
import '../repository/user_repository.dart';

class SigninUsecase{
  final UserRepository userRepository;

  SigninUsecase({
    required this.userRepository
  });

  Future<Either<Failure,Model>> excute(UserEntity user)  async{
    return userRepository.signIn(user);
  }
}