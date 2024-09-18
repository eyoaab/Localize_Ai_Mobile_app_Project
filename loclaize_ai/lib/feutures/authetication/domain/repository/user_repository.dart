import 'package:dartz/dartz.dart';

import '../../../../core/error/faliure.dart';
import '../entity/user_entity.dart';

abstract class  UserRepository{
  Future<Either<Failure,UserEntity>> signIn(UserEntity user);
  Future<Either<Failure,bool>> signUp(UserEntity user);
}