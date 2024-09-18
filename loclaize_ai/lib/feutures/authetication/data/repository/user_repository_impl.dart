import 'package:dartz/dartz.dart';
import 'package:loclaize_ai/core/error/exception.dart';
import 'package:loclaize_ai/core/error/faliure.dart';
import 'package:loclaize_ai/core/network/network_info.dart';
import 'package:loclaize_ai/feutures/authetication/data/data_source/remote_dataSource.dart';
import 'package:loclaize_ai/feutures/authetication/domain/entity/user_entity.dart';
import 'package:loclaize_ai/feutures/authetication/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn(UserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.signInUser(user);
        return Right(result.toEntity()); 
      } on ServerException {
        return const Left(ServerFailure('Failed to sign in please try again'));
      } catch (e) {
        return Left(UnknownFailure(e.toString())); 
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection.')); 
    }
  }

  @override
  Future<Either<Failure, bool>> signUp(UserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.signUpUser(user);
        return Right(result); 
      } on ServerException {
        return const Left(ServerFailure('Failed to sign up. Please try again')); 
      } catch (e) {
        return Left(UnknownFailure(e.toString())); 
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection. '));
    }
  }
}
