import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> setUp() async {
  final prefs = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(prefs);
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: locator()),
  );
  
  // Register the Shar

  /****** */
  locator.registerLazySingleton(() => http.Client());
 locator.registerLazySingleton(() => InternetConnectionChecker());

  //! Data Sources
  locator.registerLazySingleton<RemoteDatasource>(
      () => RemoteDatasourceImpl(client:locator()));
  locator.registerLazySingleton<ChatRemoteDatasource>(
      () => ChatRemoteDatasourceImpl(client: locator()));
      
  
 

  //! Repositories
  locator.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
            chatRemoteDatasource: locator(),
            networkInfo: locator(),
            store: locator()
          ));

  locator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
            remoteDatasource: locator(),
            networkInfo: locator(),
            store: locator()
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