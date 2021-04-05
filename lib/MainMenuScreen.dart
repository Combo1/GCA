import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gca/ConnectFourScreen.dart';
import 'package:gca/TicTacToeScreen.dart';

import 'ReactionGameScreen.dart';

class GridDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class MainMenuScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Games Collection')),
          backgroundColor: Color.fromRGBO(100, 32, 40, 1),
        ),
        body: GridView.extent(
          maxCrossAxisExtent: 150,
          padding: const EdgeInsets.all(4),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            ElevatedButton(
              child: Center(child: Text('Tic Tac Toe')),
              onPressed: () => this.onTicTacToePressed(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[900], // background
                onPrimary: Colors.white, // foreground
              ),
            ),
            GridDivider(),
            ElevatedButton(
              child: Center(child: Text('Connect Four')),
              onPressed: () => this.onConnectFourPressed(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[900], // background
                onPrimary: Colors.white, // foreground
              ),
            ),
            GridDivider(),
            ElevatedButton(
              child: Center(child: Text('Reaction Game')),
              onPressed: () => this.onF1GamePressed(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[900], // background
                onPrimary: Colors.white, // foreground
              ),
            ),
          ],
        ));
  }

  void onTicTacToePressed(BuildContext context) {
    Navigator.pushNamed(context, TicTacToeScreen.routeName);
  }

  void onConnectFourPressed(BuildContext context) {
    Navigator.pushNamed(context, ConnectFourScreen.routeName);
  }

  void onF1GamePressed(BuildContext context) {
    Navigator.pushNamed(context, ReactionGameScreen.routeName);
  }
}
