import 'package:dartz/dartz.dart';
import 'package:loclaize_ai/core/error/exception.dart';
import 'package:loclaize_ai/core/error/faliure.dart';
import 'package:loclaize_ai/core/network/network_info.dart';
import 'package:loclaize_ai/feutures/chat/data/data_source/remote_dataSource.dart';
import 'package:loclaize_ai/feutures/chat/domain/entity/chat_entity.dart';
import 'package:loclaize_ai/feutures/chat/domain/repository/chat_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepositoryImpl implements ChatRepository{
  final ChatRemoteDatasource chatRemoteDatasource; 
  final NetworkInfo networkInfo;
  final SharedPreferences store;

  ChatRepositoryImpl({
    required this.chatRemoteDatasource, 
    required this.networkInfo,
    required this.store,
    });

Future<String?> gettoken(String key) async {
  String? value = store.getString(key);
  return value; 
}


    @override
  Future<Either<Failure,ChatEntity>> getMessage(String message)async{
   if (await networkInfo.isConnected) {
      try {
        String? token = await gettoken('token');
        if (token == null) {
          throw Exception('token is null');
        }
        final result = await chatRemoteDatasource.getMessage(message, token);
        return Right(result.toEntity()); 
      } on ServerException {
        return const Left(ServerFailure('failed to get the response'));
      } catch (e) {
        return Left(UnknownFailure(e.toString())); 
      }
    } else {
      return const Left(ConnectionFailure('connection lost')); 
    }

  }
}