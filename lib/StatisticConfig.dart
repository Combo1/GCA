import 'package:gca/StatisticsModel.dart';

class StatConst{
  //constants for keyGame parameter
  static const KEY_REACTION_GAME = "REACTION_GAME";
  static const KEY_GAME_2048 = "GAME_2048";


  //constants for keyValue parameters
  static const KEY_PERSONAL_BEST = "PERSONAL_BEST";
  static const KEY_AMOUNT_GAMES = "AMOUNT_GAMES";
  static const KEY_MOVES_PERFORMED = "MOVES_PERFORMED";
  static const KEY_SAVEGAME_1 = "SAVE_GAME_1";
}



class StatisticConfig{
  final List <GameStatisticEntry> listDefault = <GameStatisticEntry>[];


  StatisticConfig(){
    listDefault.addAll([
      //Reaction game keys
      GameStatisticEntry.base(StatConst.KEY_REACTION_GAME, StatConst.KEY_PERSONAL_BEST, "0"),
      GameStatisticEntry.base(StatConst.KEY_REACTION_GAME, StatConst.KEY_AMOUNT_GAMES, "0"),

      //Game 2048 keys
      GameStatisticEntry.base(StatConst.KEY_GAME_2048, StatConst.KEY_AMOUNT_GAMES, "0"),
      GameStatisticEntry.base(StatConst.KEY_GAME_2048, StatConst.KEY_PERSONAL_BEST, "0"),
      GameStatisticEntry.base(StatConst.KEY_GAME_2048, StatConst.KEY_MOVES_PERFORMED, "0"),
      GameStatisticEntry.base(StatConst.KEY_GAME_2048, StatConst.KEY_SAVEGAME_1, ""),
      ],
    );
  }
}