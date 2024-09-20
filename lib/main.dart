import 'package:flutter/material.dart';
import 'package:nfc_clonner/screens/home.dart';
import 'package:nfc_clonner/screens/read.dart';
import 'package:nfc_clonner/screens/write.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: '/',
      routes:{
        '/': (context) => HomeScreen(),
        '/write':(context)=>WriteScreen(),
        '/read':(context)=>Readscreen()
      }
    );
  
  }

  
}
