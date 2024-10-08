
import 'package:dartz/dartz.dart';
import 'package:loclaize_ai/core/error/exception.dart';
import 'package:loclaize_ai/core/error/faliure.dart';
import 'package:loclaize_ai/core/network/network_info.dart';
import 'package:loclaize_ai/feutures/authetication/data/data_source/remote_dataSource.dart';
import 'package:loclaize_ai/feutures/authetication/data/model/model.dart';
import 'package:loclaize_ai/feutures/authetication/domain/entity/user_entity.dart';
import 'package:loclaize_ai/feutures/authetication/domain/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  final SharedPreferences store;

  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfo,
    required this.store,

  });

  Future<void> saveToken(String token) async {
    if (token.isNotEmpty){
    await store.setString('token', token);}
  
  }
  

  @override
  Future<Either<Failure, Model>> signIn(UserEntity user,)async {
       final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      
      try {
        final result = await remoteDatasource.signInUser(user);

        saveToken(result.token);
        return Right(result); 
      } on ServerException {
        return const Left(ServerFailure('በመለያ መግባት አልተሳካም እባክዎ እንደገና ይሞክሩ'));
      } catch (e) {
        return Left(UnknownFailure(e.toString())); 
      }
    } else {

    return const Left(ConnectionFailure('እባክዎ የበይነመረብ ግንኙነትዎን ያረጋግጡ እና እንደገና ይሞክሩ')); 

    }
  }

  @override
  Future<Either<Failure, String>> signUp(UserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.signUpUser(user);
        return Right(result); 
      } on ServerException {
        return const Left(ServerFailure('መመዝገብ አልተሳካም። እባክህ እንደገና ሞክር')); 
      } catch (e) {
        return Left(UnknownFailure(e.toString())); 
      }
    } else {
      return const Left(ConnectionFailure('እባክዎ የበይነመረብ ግንኙነትዎን ያረጋግጡ እና እንደገና ይሞክሩ')); 

    }
  }
}
