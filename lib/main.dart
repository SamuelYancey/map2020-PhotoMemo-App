import 'package:flutter/material.dart';
import 'package:photomemo/screens/signin_screen.dart';

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
        
      }
    );
  }

}