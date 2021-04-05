
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
//import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class StatisticsModel extends ChangeNotifier {
  List<GameStatisticEntry> _gameValues = <GameStatisticEntry>[];
  Future<SharedPreferences> _prefs;


  StatisticsModel() {
    loadValues();
  }

  void loadValues() {
    _prefs = SharedPreferences.getInstance();
    _prefs.then((value) {
    String jsonData =  value.getString("statistics"); //json data
    //parse to game statistics
    print('DataFromSharedStorage: $jsonData');
    if (jsonData != '' && jsonData != null) {
      var dataObjsJson = jsonDecode(jsonData);
      var array = dataObjsJson["data"];
      var arr1 = jsonDecode(array);
      arr1.forEach((entryJson) {
        print(entryJson['keyGame']);
        GameStatisticEntry newEntry = GameStatisticEntry.fromJson(entryJson);
        //print('To look at: ${newEntry.keyGame}, ${newEntry.keyValue}, ${newEntry.value}');
        if(newEntry.keyGame != "null" && newEntry.keyValue != "null" && newEntry.keyGame != null && newEntry.keyValue != null && !this.containsKey(newEntry.keyGame, newEntry.keyValue)){
          _gameValues.add(newEntry);
        }
      }
      );

      //_gameValues.addAll(values);
    } else {
      _gameValues = <GameStatisticEntry>[];
    }
  });
  }

  void initDone() async{
    await _prefs;
  }

  void saveValues() {
    _prefs.then((value) {
      String encoded = jsonEncode(_gameValues);
      Map<String, dynamic> json = Map();
      json['data'] = encoded;
      String jsonEncoded  = jsonEncode(json);
      value.setString("statistics", jsonEncoded);
    });
  }

  void resetScore(){
    print('reset score');
    _prefs.then((value) {
      value.setString("statistics", "");
    });
  }

  String getValue(String keyGame, String keyValue){
    if(!this.containsKey(keyGame, keyValue)) {
      return "null";
    }else{
      return _gameValues.firstWhere((element) => element.contains(keyGame, keyValue)).value;
    }
  }

  bool containsKey(String keyGame, String keyValue){
    return _gameValues.any((element) => element.contains(keyGame, keyValue));
  }

  void setValue(String keyGame, String keyValue, String value){
    if(this.containsKey(keyGame, keyValue)){
      _gameValues.firstWhere((element) => element.contains(keyGame, keyValue)).value = value;
    }else{
      print("Key doesn't exist, create new entry");
      GameStatisticEntry newGameData = GameStatisticEntry.base(keyGame, keyValue, value);
      _gameValues.add(newGameData);
    }
    saveValues();
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