import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gca/ConnectFourScreen.dart';
import 'package:gca/TicTacToeScreen.dart';

class MainMenuScreen extends StatelessWidget{
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView(
        children: [
          ElevatedButton(child: Center(child: Text('Tic Tac Toe')), onPressed: () => this.onTicTacToePressed(context), ),
          Divider(),
          ElevatedButton(child: Center(child: Text('Connect Four')), onPressed: () => this.onConnectFourPressed(context), ),
        ],
      )
    );
  }


  void onTicTacToePressed(BuildContext context){
    Navigator.pushNamed(context, TicTacToeScreen.routeName);
  }

  void onConnectFourPressed(BuildContext context){
    Navigator.pushNamed(context, ConnectFourScreen.routeName);
  }

}