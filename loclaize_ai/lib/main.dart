import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:loclaize_ai/feutures/authetication/presentation/bloc/user_bloc.dart';
import 'package:loclaize_ai/feutures/authetication/presentation/pages/splash_screen.dart';
import 'package:loclaize_ai/feutures/chat/presentation/bloc/chat_bloc.dart';
  
import 'injection_container.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setUp(); 

  runApp(
    DevicePreview(
    builder: (context) => MyApp(),
  ),);

  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create:(context)=>locator<UserBloc>()),
        
        BlocProvider<ChatBloc>(
          create: (context) => locator<ChatBloc>(), 
        ),
      ],  
      child: MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
       
      ),
    );
  }
}