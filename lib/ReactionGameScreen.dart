
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gca/StatisticsModel.dart';
import 'package:provider/provider.dart';



class ReactionGameScreen extends StatefulWidget {
  static const routeName = '/games/reaction-game/in-progress';
  final int _tilesPerSide;

  ReactionGameScreen(this._tilesPerSide);

  @override
  State<StatefulWidget> createState() => _ReactionGameScreenState(this._tilesPerSide);
}

class _ReactionGameScreenState extends State<ReactionGameScreen> with SingleTickerProviderStateMixin{
  static const REACTION_GAME_KEY = 'REACTION_GAME';
  static const HIGHSCORE_KEY = 'HIGHSCORE_KEY';
  //animation time left
  AnimationController _controller;

  List<bool> _isPrimaryColor = List<bool>.generate(16, (index) => false);
  @required
  Color primaryColor;
  String primaryColorText;
  @required
  Color secondaryColor;
  String secondaryColorText;
  Random _random = Random();
  final int _tilesPerSide;
  int _tilesCount;

  //scenario info
  bool _flipToPrimaryColorOnly;
  int _counterSolved;
  int _pointsForSolving;
  //game info
  static const int gameDuration = 10;
  bool _isGameRunning = false;



  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(seconds: gameDuration),
    );
    _controller.addStatusListener((status) {
      //print('Status: ${status}');
      if(status == AnimationStatus.completed){

          this.onTimerComplete();


      }
    });
    _controller.reset();
    _controller.forward();
    Provider.of<StatisticsModel>(context, listen: false).initDone();
  }

  @override
  void didUpdateWidget(ReactionGameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    //_controller.duration = Duration(seconds: 60);
  }



  _ReactionGameScreenState(this._tilesPerSide){
    this._tilesCount = _tilesPerSide * _tilesPerSide;
    primaryColor = Colors.black;
    secondaryColor = Colors.white;
    _flipToPrimaryColorOnly = true;
    _counterSolved = 0;
    configureNextScenario();
    initGame();
  }

  void initGame(){
    //set Counter
    _counterSolved = 0;
    _isGameRunning = true;
    //timer = Timer(Duration(seconds: 60), this.onTimerComplete);
    if(_controller != null){
      _controller.reset();
      _controller.forward();
    }
    configureNextScenario();

  }

  void onTimerComplete(){
    setState(() {
      _isGameRunning = false;
      //set score
      //get current highscore
      String currentHighscore = Provider.of<StatisticsModel>(context, listen: false).getValue(REACTION_GAME_KEY, HIGHSCORE_KEY);
      print('Read Value: $currentHighscore');
      int score = (currentHighscore == "null" || currentHighscore == null)? 0: int.parse(currentHighscore);
      print('Read score: $score, new score: $_counterSolved');
      if(_counterSolved > score){
        //save new highscore
        Provider.of<StatisticsModel>(context, listen: false).setValue(REACTION_GAME_KEY, HIGHSCORE_KEY, "$_counterSolved");
      }
    });
  }


  @override
  void dispose(){
    _controller.stop();
    _controller.dispose();//Animation controller disposal must happen before super.dispose(); (source: https://stackoverflow.com/questions/58802223/flutter-ticker-must-be-disposed-before-calling-super-dispose)
    super.dispose();

  }

  void generateRandomColors(){
    List<Color> colors = <Color>[Colors.black, Colors.white, Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.purple[400], ];
    List<String> colorText = <String>['Black', 'White', 'Red', 'Blue', 'Green', 'Yellow', 'Orange', 'Purple',];

    int firstIndex = _random.nextInt(colors.length);


    int secondIndex = _random.nextInt(colors.length);
    while(firstIndex == secondIndex){
      secondIndex = _random.nextInt(colors.length);
    }
    primaryColor = colors[firstIndex];
    primaryColorText = colorText[firstIndex];
    secondaryColor = colors[secondIndex];
  }

  void onTapDownContainer(int index){
    //print('Event received');
    if(_isGameRunning) {
      setState(() {
        _isPrimaryColor[index] = !_isPrimaryColor[index];
        //generate new scenario, if condition fullfilled
        if (isScenarioConditionFullfilled()) {
          //generate next scenario
          _counterSolved += _pointsForSolving;
          configureNextScenario();
        }
      });
    }
  }

  void retryGame(){
    //print('here');
    setState(() {
      this.initGame();
    });
  }

  void backToMainMenu(){
    Navigator.pop(context);
  }

  void configureNextScenario(){

      _flipToPrimaryColorOnly = _random.nextBool();
      if(_flipToPrimaryColorOnly){
        bool isEasy = _random.nextBool();
        int toSolve = isEasy ? this._tilesCount~/3 : (2 * this._tilesCount~/3);
        generateRandomScenario(toSolve, _flipToPrimaryColorOnly);
        _pointsForSolving = isEasy? 1: 2;
      }else{
        //flip to either side
        generateRandomScenario(this._tilesCount~/3, _flipToPrimaryColorOnly);
        _pointsForSolving = 1;
      }

  }

  bool isScenarioConditionFullfilled(){
    if(_flipToPrimaryColorOnly){
      return this._tilesCount == countPrimaryTiles();
    }else{
      int count = countPrimaryTiles();
      return count == this._tilesCount || 0 == countPrimaryTiles();
    }
  }



  void generateRandomScenario(int _flippedTiles, bool _flipToPrimaryColorOnly){
    //scenario 0: all to primary color
    generateRandomColors();
    List<int> flippedIndices = <int>[];
    List<int> tiles = List.generate(this._tilesCount, (index) => index);
    for(int i = 0; i < _flippedTiles; i++){
      int rndIndex = _random.nextInt(tiles.length);
      flippedIndices.add(tiles.removeAt(rndIndex));
    }
    //apply to layout
    for(int i = 0; i < this._tilesCount; i++){
      _isPrimaryColor[i] = true;
    }
    for (int i in flippedIndices){
      _isPrimaryColor[i] = false;
    }
  }

  int countPrimaryTiles(){
    int res = 0;
    for(int i = 0; i < this._tilesCount; i++){
      if(_isPrimaryColor[i]){
        res++;
      }
    }
    return res;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

            body: SafeArea(child: Container(color: Colors.tealAccent, child:
            Padding(

              padding: EdgeInsets.only(top: 30,),
              child:
                _buildGameContent(context),
            ),
            ),
            ),
    );
  }

  Widget _buildGameContent(BuildContext context){
    if(this._isGameRunning){
      return Column(children: [
        Text('Score: ${this._counterSolved}', style: const TextStyle(fontSize: 30)),
        //Text('Remaining time: ${_controller.duration.inSeconds}', style: const TextStyle(fontSize: 30)),
        Countdown(
        animation: StepTween(
        begin: gameDuration,
        end: 0,
        ).animate(_controller),),
        Text(_flipToPrimaryColorOnly?'${this.primaryColorText}': '', style: TextStyle(fontSize: 30, color: (this._flipToPrimaryColorOnly) ? this.primaryColor:Colors.black), ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          padding: const EdgeInsets.all(20),
          //crossAxisSpacing: 10,
          //mainAxisSpacing: 10,
          //crossAxisCount: 3,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: this._tilesPerSide,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),

          itemCount: this._tilesCount,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTapDown: (e) => this.onTapDownContainer(index),
              child:
              Container(
                padding: const EdgeInsets.all(8),
                color: (_isPrimaryColor[index])?primaryColor: secondaryColor,
              ),
            );
          },
      ),
      ],
      );
    }else{
      //show buttons retry and back to menu
      //Expanded(child: SizedBox.expand());
      return
        Consumer<StatisticsModel>(
          builder: (context, model, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('Your Score: ${this._counterSolved}', style: TextStyle(fontSize: 40)),),
                Center(child: Text('Best Score: ${(model.getValue(REACTION_GAME_KEY, HIGHSCORE_KEY) != "null")?model.getValue(REACTION_GAME_KEY, HIGHSCORE_KEY) : '0'}', style: TextStyle(fontSize: 40)),),
                SizedBox(height: 100,),
                ElevatedButton(onPressed: this.retryGame, child: Padding(padding: EdgeInsets.all(10,), child: Text('Retry', style: TextStyle(fontSize: 30))),),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: this.backToMainMenu, child: Padding(padding: EdgeInsets.all(10,), child: Text('Back', style: TextStyle(fontSize: 30))),),
              ],
            );
          }
        )
        ;
    }
  }
}

class Countdown extends AnimatedWidget {
  Countdown({ Key key, this.animation }) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context){

    Duration clockTimer = Duration(seconds: animation.value);

    String timerText = '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 40,
        color: Colors.black,
      ),
    );

  }
}