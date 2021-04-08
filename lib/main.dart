import 'package:flutter/material.dart';
import 'package:gca/F1ReactionGameScreen.dart';
import 'package:gca/MainMenuScreen.dart';
import 'package:gca/StatisticsModel.dart';
import 'package:gca/TicTacToeScreen.dart';

import 'ConnectFourScreen.dart';
import 'ReactionGameScreen.dart';

import 'package:provider/provider.dart';


void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => StatisticsModel(),
      child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Collection App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        TicTacToeScreen.routeName: (context) => TicTacToeScreen(),
        TicTacToePVCScreen.routeName: (context) => TicTacToePVCScreen(),
        TicTacToePVPScreen.routeName: (context) => TicTacToePVPScreen(),
        MainMenuScreen.routeName: (context) => MainMenuScreen(),
        ConnectFourScreen.routeName: (context) => ConnectFourScreen(),
        ReactionGameScreen.routeName: (context) => ReactionGameScreen(4),
        F1ReactionGameStartScreen.routeName: (context) => F1ReactionGameStartScreen(),
      },
      initialRoute: MainMenuScreen.routeName,
    );
  }

}
