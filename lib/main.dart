import 'package:flutter/material.dart';
import 'package:gca/F1ReactionGameScreen.dart';
import 'package:gca/MainMenuScreen.dart';
import 'package:gca/StatisticsModel.dart';
import 'package:gca/RockPaperScissors.dart';
import 'package:gca/TicTacToeScreen.dart';
import 'package:page_transition/page_transition.dart';

import '2048Screen.dart';
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
        MainMenuScreen.routeName: (context) => MainMenuScreen(),
      },
      initialRoute: MainMenuScreen.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case ReactionGameScreen.routeName:
            return PageTransition(
              child: ReactionGameScreen(4),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
            break;
          case ConnectFourScreen.routeName:
            return PageTransition(
              child: ConnectFourScreen(),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
            break;
          case ConnectFourPVCScreen.routeName:
            return PageTransition(
              child: ConnectFourPVCScreen(),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
            break;
          case ConnectFourPVPScreen.routeName:
            return PageTransition(
              child: ConnectFourPVPScreen(),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
            break;
          case TicTacToeScreen.routeName:
            return PageTransition(
              child: TicTacToeScreen(),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
            break;
          case TicTacToePVPScreen.routeName:
            return PageTransition(
              child: TicTacToePVPScreen(),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
            break;
          case TicTacToePVCScreen.routeName:
            return PageTransition(
              child: TicTacToePVCScreen(),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
            break;
          case RPSScreen.routeName:
            return PageTransition(
              child: RPSScreen(),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
            break;
          case RPSStandardScreen.routeName:
            return PageTransition(
              child: RPSStandardScreen(),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
            break;
          case Game2048Screen.routeName:
            return PageTransition(
              child: Game2048Screen(),
              type: PageTransitionType.fade,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
            );
          default:
            return null;
        }
      },
    );
  }

}
