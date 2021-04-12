
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gca/StatisticConfig.dart';
//import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class StatisticsModel extends ChangeNotifier {
  List<GameStatisticEntry> _gameValues = <GameStatisticEntry>[];
  SharedPreferences _prefs;
  bool isLoadCompleted;

  StatisticsModel(){
    _gameValues = StatisticConfig().listDefault;
    isLoadCompleted = false;
    loadValues().then((value) {
      isLoadCompleted = true;
      //print('Load completed');
    });
  }


  Future<void> loadValues() async {
    //print('Init loadValues: $isLoadCompleted');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    String jsonData =  prefs.getString("statistics"); //json data
    //parse to game statistics
    print('DataFromSharedStorage: $jsonData');
    if (jsonData != '' && jsonData != null) {
      var dataObjsJson = jsonDecode(jsonData);
      var array = dataObjsJson["data"];
    var arr1 = jsonDecode(array);
      arr1.forEach((entryJson) {
        GameStatisticEntry newEntry = GameStatisticEntry.fromJson(entryJson);
        //print('To look at: ${newEntry.keyGame}, ${newEntry.keyValue}, ${newEntry.value}');
        if (newEntry.keyGame != "null" && newEntry.keyValue != "null" &&
            newEntry.keyGame != null && newEntry.keyValue != null &&
            !this.containsKey(newEntry.keyGame, newEntry.keyValue)) {
          _gameValues.add(newEntry);
        }else if(this.containsKey(newEntry.keyGame, newEntry.keyValue)){
          //default value exists, overwrite value
          setValue(newEntry.keyGame, newEntry.keyValue, newEntry.value, saveToDisk: false);
        }
      });

      //_gameValues.addAll(values);
    } else {
      _gameValues = <GameStatisticEntry>[];
    }
  }



  void saveValues() {
    if(_prefs != null){
      String encoded = jsonEncode(_gameValues);
      Map<String, dynamic> json = Map();
      json['data'] = encoded;
      String jsonEncoded  = jsonEncode(json);
      _prefs.setString("statistics", jsonEncoded);
      print('Values saved: $jsonEncoded');
    }
  }

  void resetAllStats(){
    loadValues().then((value) {
      print('reset all stats');
      _gameValues = StatisticConfig().listDefault;
      saveValues();
    });
  }

  void resetStatsGame(String keyGame){
    loadValues().then((value) {
      print('reset stats for game with key $keyGame');
      //delete old keys from list
      _gameValues.removeWhere((element) => element.keyGame == keyGame);
      //insert default values to list
      StatisticConfig().listDefault.forEach((element) {
        if(element.keyGame == keyGame){
          _gameValues.add(element);
        }
      });
      //save changes
      saveValues();
    });

  }

  String getValue(String keyGame, String keyValue){
    //print('Data Access');
    if(!this.containsKey(keyGame, keyValue)) {
      return "null";
    }else{
      return _gameValues.firstWhere((element) => element.contains(keyGame, keyValue)).value;
    }
  }

  bool containsKey(String keyGame, String keyValue){
    return _gameValues.any((element) => element.contains(keyGame, keyValue));
  }

  void setValue(String keyGame, String keyValue, String value, {bool saveToDisk =true}){
    if(this.containsKey(keyGame, keyValue)){
      _gameValues.firstWhere((element) => element.contains(keyGame, keyValue)).value = value;
    }else{
      print("Key doesn't exist, create new entry");
      GameStatisticEntry newGameData = GameStatisticEntry.base(keyGame, keyValue, value);
      _gameValues.add(newGameData);
    }
    if(saveToDisk){
      saveValues();
    }
    notifyListeners();
  }


}

//@JsonSerializable()
class GameStatisticEntry{
  String keyGame;
  String keyValue;
  String value;

  GameStatisticEntry.base(this.keyGame, this.keyValue, this.value);


  GameStatisticEntry.fromJson(Map<String, dynamic> json):
    keyGame = json['keyGame'],
    keyValue = json['keyValue'],
    value = json['value'];

/*
  GameStatisticEntry.fromJson(dynamic json) {
   GameStatisticEntry.base(json['keyGame'] as String, json['keyValue'] as String, json['value'] as String);
  }
*/
  Map<String, dynamic> toJson() =>
  {
    'keyGame': keyGame,
    'keyValue': keyValue,
    'value': value,
  };

  bool contains(String keyGame, String keyValue){
    return this.keyGame == keyGame && this.keyValue == keyValue;
  }




}