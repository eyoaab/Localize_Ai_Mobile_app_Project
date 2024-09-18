import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:loclaize_ai/core/network/network_info.dart';
import 'package:loclaize_ai/feutures/authetication/data/data_source/remote_dataSource.dart';
import 'package:loclaize_ai/feutures/authetication/data/repository/user_repository_impl.dart';
import 'package:loclaize_ai/feutures/authetication/domain/repository/user_repository.dart';
import 'package:loclaize_ai/feutures/authetication/domain/usecase/signin_usecase.dart';
import 'package:loclaize_ai/feutures/authetication/domain/usecase/signup_usecase.dart';
import 'package:loclaize_ai/feutures/authetication/presentation/bloc/user_bloc.dart';
import 'package:loclaize_ai/feutures/chat/data/data_source/remote_dataSource.dart';
import 'package:loclaize_ai/feutures/chat/data/repository/chat_repository_impl.dart';
import 'package:loclaize_ai/feutures/chat/domain/repository/chat_repository.dart';
import 'package:loclaize_ai/feutures/chat/domain/usecase/get_chat_usecase.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_bloc.dart';

final locator = GetIt.instance;

Future<void> setUp() async {
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => Connectivity());
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  //! Data Sources
  locator.registerLazySingleton<RemoteDatasource>(
      () => RemoteDatasourceImpl(client:locator()));
  locator.registerLazySingleton<ChatRemoteDatasourceImpl>(
      () => ChatRemoteDatasourceImpl(client: locator()));
      
  
 

  //! Repositories
  locator.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
            chatRemoteDatasource: locator(),
            networkInfo: locator(),
          ));

  locator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
            remoteDatasource: locator(),
            networkInfo: locator(),
          ));


  //! Use Cases
  locator.registerLazySingleton(() => GetChatUsecase(chatRepository: locator()));


  locator.registerLazySingleton(() => SigninUsecase(userRepository:locator()));
  locator.registerLazySingleton(() => SignupUsecase(userRepository:locator()));

  //! BLoC
  locator.registerFactory(() => UserBloc(
        signUpUsecase: locator(),
        signInUsecase: locator(),

    
       
      ));

  locator.registerFactory(() => ChatBloc(
        get_chat_usecase: locator(),
      ));
}