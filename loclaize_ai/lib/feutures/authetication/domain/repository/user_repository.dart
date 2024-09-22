import 'package:dartz/dartz.dart';
import 'package:loclaize_ai/feutures/authetication/data/model/model.dart';

import '../../../../core/error/faliure.dart';
import '../entity/user_entity.dart';

abstract class  UserRepository{
  Future<Either<Failure,Model>> signIn(UserEntity user);
  Future<Either<Failure,String>> signUp(UserEntity user);
}