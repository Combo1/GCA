import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gca/2048Screen.dart';
import 'package:gca/StatisticConfig.dart';
import 'package:provider/provider.dart';

import 'StatisticsModel.dart';

class Game2048OverviewScreen extends StatefulWidget{
  static const routeName = '/games/2048/overview';

  @override
  State<StatefulWidget> createState() {
    return Game2048OverviewState();
  }

}




class Game2048OverviewState extends State<Game2048OverviewScreen>{
  String _highscore;
  String _gamesPlayed;
  String _movesPerformed;
  bool _hasSaveGame = false;


  @override
  void initState(){
    super.initState();
    //load values

    Provider.of<StatisticsModel>(context, listen: false).loadValues();  //ensures loading of stats in shared preferences
    String tagGame = StatConst.KEY_GAME_2048;
    _highscore = Provider.of<StatisticsModel>(context, listen: false).getValue(tagGame, StatConst.KEY_PERSONAL_BEST);
    _gamesPlayed = Provider.of<StatisticsModel>(context, listen: false).getValue(tagGame, StatConst.KEY_AMOUNT_GAMES);
    _movesPerformed = Provider.of<StatisticsModel>(context, listen: false).getValue(tagGame, StatConst.KEY_MOVES_PERFORMED);
    String _saveGame = Provider.of<StatisticsModel>(context, listen: false).getValue(tagGame, StatConst.KEY_SAVEGAME_1);
    _hasSaveGame = _saveGame != "";
    print(_saveGame);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);//force potrait mode in this mode
  }

  @override
  void dispose(){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight,]);//force potrait mode in this mode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle styleStats = TextStyle(fontSize: 22, color: Colors.white, decoration: TextDecoration.none,////set decoration to .none
      fontWeight: FontWeight.bold,  );
    TextStyle styleButtons = TextStyle(fontSize: 36, color: Colors.lightBlueAccent.shade400, decoration: TextDecoration.none, fontWeight: FontWeight.bold, );
    TextStyle styleTitle = TextStyle(fontSize: 60, color: Colors.white, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, decorationColor: Colors.white, decorationStyle: TextDecorationStyle.solid, );
    return
      SafeArea(
        child: Container(
          color: Colors.amberAccent.shade400,
          child: Consumer<StatisticsModel>(builder: (context, value, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 50,),
              Text('2048', style: styleTitle, textAlign: TextAlign.center, ),
              SizedBox(height: 30,),
              Text('Highscore: ${value.getValue(StatConst.KEY_GAME_2048, StatConst.KEY_PERSONAL_BEST)}', style: styleStats, textAlign: TextAlign.center,),
              Text('Games played: ${value.getValue(StatConst.KEY_GAME_2048, StatConst.KEY_AMOUNT_GAMES)}', style: styleStats, textAlign: TextAlign.center,),
              Text('Swipes Counter: ${value.getValue(StatConst.KEY_GAME_2048, StatConst.KEY_MOVES_PERFORMED)}', style: styleStats, textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              _buildContinueWidget(styleButtons, value.getValue(StatConst.KEY_GAME_2048, StatConst.KEY_SAVEGAME_1)),

              CupertinoButton(onPressed: this.onNewGamePressed, child: Padding(padding: EdgeInsets.all(5), child: Text('New Game', style: styleButtons),),),
            ],
          ),
        ),
        ),
      );
  }

  Widget _buildContinueWidget(TextStyle styleButton, String savegameData){
    _hasSaveGame = savegameData != "";
    if(_hasSaveGame) {
      return CupertinoButton(onPressed: this.onContinuePressed,
          child: Padding(padding: EdgeInsets.all(5),
            child: Text('Continue', style: styleButton),));
    }else{
      return Container();
    }
  }

  void onContinuePressed(){
    //load level and initiate screen
    Navigator.pushNamed(context, Game2048Screen.routeName);
  }

  void onNewGamePressed(){
    //TODO show dialog
    //replace screen
    String savegame = Provider.of<StatisticsModel>(context, listen: false).getValue(StatConst.KEY_GAME_2048, StatConst.KEY_SAVEGAME_1);
    bool hasSavegame = savegame != "";
    if(!_hasSaveGame){
      //no savegame exists, start new game
      Navigator.pushNamed(context, Game2048Screen.routeName);
    }else{
      //ask for permission to create a new game
      _showCreateNewGameDialog();
    }
  }

  void _showCreateNewGameDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete old Save"),
          content: new Text("Another save was found. Do you want to delete the old save and start a new game?"),
          actions: <Widget>[
            new TextButton(
              child: new Text("Start new Game"),
              onPressed: () {
                //delete old game and init new game
                Provider.of<StatisticsModel>(context, listen: false).setValue(StatConst.KEY_GAME_2048, StatConst.KEY_SAVEGAME_1, "");
                Navigator.pop(context);
                Navigator.pushNamed(context, Game2048Screen.routeName);
              },
            ),
            new TextButton(
              child: new Text("Cancel"),
              onPressed: () {
                //Nothing happens
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

}