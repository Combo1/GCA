import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gca/ConnectFourScreen.dart';
import 'package:gca/StatisticConfig.dart';
import 'package:gca/StatisticsModel.dart';
import 'package:gca/TicTacToeScreen.dart';
import 'package:provider/provider.dart';

import 'ReactionGameScreen.dart';

class MainMenuScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Games Collection')),
        ),
        body: ListView(
          children: [
            ElevatedButton(
              child: Center(child: Text('Tic Tac Toe')),
              onPressed: () => this.onTicTacToePressed(context),
            ),
            Divider(),
            ElevatedButton(
              child: Center(child: Text('Connect Four')),
              onPressed: () => this.onConnectFourPressed(context),
            ),
            Divider(),
            ElevatedButton(
              child: Center(child: Text('Reaction Game')),
              onPressed: () => this.onF1GamePressed(context),
            ),
            ElevatedButton(onPressed: () => this.resetAllStats(context), child: Center(child: Text('Reset All', )),),
            ElevatedButton(onPressed: () => this.resetReactionGameStats(context), child: Center(child: Text('Reset Reaction Game Stats'))),
          ],
        ));
  }

  void resetAllStats(BuildContext context){
    Provider.of<StatisticsModel>(context, listen: false).resetAllStats();
  }

  void resetReactionGameStats(BuildContext context){
    Provider.of<StatisticsModel>(context, listen: false).resetStatsGame(StatConst.KEY_REACTION_GAME);
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
