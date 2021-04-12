import 'package:gca/StatisticsModel.dart';

class StatConst{
  //constants for keyGame parameter
  static const KEY_REACTION_GAME = "REACTION_GAME";


  //constants for keyValue parameters
  static const KEY_PERSONAL_BEST = "PERSONAL_BEST";
  static const KEY_AMOUNT_GAMES = "AMOUNT_GAMES";
}



class StatisticConfig{
  final List <GameStatisticEntry> listDefault = <GameStatisticEntry>[];


  StatisticConfig(){
    listDefault.addAll([
      GameStatisticEntry.base(StatConst.KEY_REACTION_GAME, StatConst.KEY_PERSONAL_BEST, "0"),
      GameStatisticEntry.base(StatConst.KEY_REACTION_GAME, StatConst.KEY_AMOUNT_GAMES, "0"),
      ],
    );
  }
}