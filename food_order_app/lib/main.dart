import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Controller/CartProvider.dart';
import 'UI/MainHome.dart';
import 'UI/login.dart';
import 'UI/register.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){

    return ChangeNotifierProvider(
      create: (_)=>cartProvider(),
      child: Builder(builder: (BuildContext context){
        return MaterialApp(

          debugShowCheckedModeBanner: false,
          initialRoute: 'login',
          routes: {
            'login':(context)=>const MyLogin(),
            'register':(context)=>const MyRegister(),
            'home':(context)=>const MyHome(items: '',url: '',username: ''),

          },
        );
      }),
    );
  }
}



