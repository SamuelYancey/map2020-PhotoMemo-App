import 'package:flutter/material.dart';
import 'package:photomemo/screens/add_screen.dart';
import 'package:photomemo/screens/chat_screen.dart';
import 'package:photomemo/screens/detailed_screen.dart';
import 'package:photomemo/screens/edit_screen.dart';
import 'package:photomemo/screens/home_screen.dart';
import 'package:photomemo/screens/sendmessage_screen.dart';
import 'package:photomemo/screens/settings_screen.dart';
import 'package:photomemo/screens/sharedwith_screen.dart';
import 'package:photomemo/screens/signin_screen.dart';
import 'package:photomemo/screens/signup_screen.dart';

void main(){
  runApp(PhotoMemoApp());
}

class PhotoMemoApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        AddScreen.routeName: (context) => AddScreen(),
        DetailedScreen.routeName: (context) => DetailedScreen(),
        EditScreen.routeName: (context) => EditScreen(),
        SharedWithScreen.routeName: (context) => SharedWithScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        ChatScreen.routeName: (context) => ChatScreen(),
        SendMessageScreen.routeName: (context) => SendMessageScreen(),
      }
    );
  }

}