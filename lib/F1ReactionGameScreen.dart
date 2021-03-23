

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class F1ReactionGameStartScreen extends StatelessWidget{
  static const routeName = '/games/f1-reaction-game';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        SafeArea(child:
          Column(children: [
            Text('Your last highscore: 0 (Coming soon)'),
            ElevatedButton(onPressed: () => this.onStartPressed(context), child: Text('Start Game')),
          ],
        ),
        ),
    );
  }

  void onStartPressed(BuildContext context){
    Route route = MaterialPageRoute(builder: (context) => F1ReactionGameScreen());
    Navigator.pushReplacement(context, route);
  }

}

enum F1ReactionGameState{
  init,
  before_light_1,
  light_1,
  light_2,
  light_3,
  light_4,
  light_5,
  lights_out,
  cancelled,
}


class F1ReactionGameScreen extends StatefulWidget{
  static const routeName = '/games/f1-reaction-game/in-progress';


  
  @override
  State<StatefulWidget> createState() => _F1ReactionGameScreenState();

}

class _F1ReactionGameScreenState extends State<F1ReactionGameScreen>{
  F1ReactionGameState gameState = F1ReactionGameState.before_light_1;
  bool _isGameCompleted;
  bool _isValidResult;
  int _millisecondScore;
  Stopwatch watch;
  Timer timer;


  _F1ReactionGameScreenState(){
    this.startTimer();
    watch = Stopwatch();
    _isGameCompleted = false;
    _isValidResult = false;
    _millisecondScore = 0;
  }

  int getCountdownToNextState(F1ReactionGameState currentState){
    switch(currentState) {
      case F1ReactionGameState.before_light_1:
        return 2000 + Random().nextInt(2000);
      case F1ReactionGameState.light_1:
        return 1000;
      case F1ReactionGameState.light_2:
        return 1000;
      case F1ReactionGameState.light_3:
        return 1000;
      case F1ReactionGameState.light_4:
        return 1000;
      case F1ReactionGameState.light_5:
        return 200 + Random().nextInt(2800);
      default:
        return 0;
    }
  }


  @override
  Widget build(BuildContext context) {
    _F1ReactionGameScreenState _curState = this;
    return Scaffold(body: Padding(
      padding: EdgeInsets.only(top: 50,),
      child:
      Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20,),
          child:
        FittedBox(
          fit: BoxFit.fitWidth,
          child: SizedBox(
            width: 1000,
            height: 650,
            child: CustomPaint(
              painter: LightSystemPainter(_curState)),
          ),
          ),
        ),
          Text('${this._isGameCompleted} , ${this._isValidResult}, ${this._millisecondScore}'),
          //ElevatedButton(onPressed: () => this.onPressedGoButton(context), child: Text('Go!')),
          GestureDetector(child:
            SizedBox.fromSize(size: Size(400, 150),
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(),
                ),
                child: Text(
                  'Go!',
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
            onTapUp: (e) => this.onPressedGoButton(context),),

        ],
      ),
      ),
    );
  }
  void onPressedGoButton(BuildContext context){
    this.stopStopwatch();
  }

  void startTimer(){
    if(gameState != F1ReactionGameState.lights_out && gameState != F1ReactionGameState.cancelled){
      //only start timer if not in end state
      final int msValue = getCountdownToNextState(gameState);
      Duration ms = Duration(milliseconds: msValue);
      timer = Timer(ms, this.onTimerCompleted);
      //timer.
    }
  }

  @override
  void dispose(){
    super.dispose();
    //stop timer
    if(timer != null){
      timer.cancel();
    }
  }

  void startStopwatch(){
    watch.start();
  }

  void stopStopwatch(){
    setState((){
    watch.stop();
    if(gameState == F1ReactionGameState.lights_out && !_isGameCompleted){
      //setState(() {
        _millisecondScore = watch.elapsedMilliseconds;
        _isGameCompleted = true;
        _isValidResult = true;
      //});
    }else if(!_isGameCompleted){
      //setState(() {
        _isValidResult = false;
        _isGameCompleted = true;
      //});
    }
    });
  }

  void onTimerCompleted(){
    setState(() {
      switch(gameState){
        case F1ReactionGameState.before_light_1:
          gameState = F1ReactionGameState.light_1;
          break;
        case F1ReactionGameState.light_1:
          gameState = F1ReactionGameState.light_2;
          break;
        case F1ReactionGameState.light_2:
          gameState = F1ReactionGameState.light_3;
          break;
        case F1ReactionGameState.light_3:
          gameState = F1ReactionGameState.light_4;
          break;
        case F1ReactionGameState.light_4:
          gameState = F1ReactionGameState.light_5;
          break;
        case F1ReactionGameState.light_5:
          gameState = F1ReactionGameState.lights_out;
          break;
        default:
      }
    });
    this.startTimer();
  }


}

class LightSystemPainter extends CustomPainter{

  _F1ReactionGameScreenState _currentState;
  F1ReactionGameState _previousState;

  double _paddingWidth = 100;
  double _radius = 50;
  double _paddingHeight = 50;
  double _diffTrafficLightWidth = 10;
  double _diffTrafficLightHeight = 20;
  var _lights;
  static const int ALL_OFF = 0x0;
  static const int L_1_ON = 0x10;
  static const int L_2_ON = 0x18;
  static const int L_3_ON = 0x1C;
  static const int L_4_ON = 0x1E;
  static const int L_5_ON = 0x1F;

  LightSystemPainter(this._currentState){
    _previousState = F1ReactionGameState.init;
    int columns = 5;
    int rows = 4;
    _lights = List.generate(columns, (index) => List.filled(rows, false), growable: false);
  }

  void applyState(F1ReactionGameState state){

    _previousState = state;
    switch(state)
    {
      //all off
    case F1ReactionGameState.light_1:
      setLightState(false, false, L_1_ON);
      break;
    case F1ReactionGameState.light_2:
      setLightState(false, false, L_2_ON);
      break;
    case F1ReactionGameState.light_3:
      setLightState(false, false, L_3_ON);
      break;
    case F1ReactionGameState.light_4:
      setLightState(false, false, L_4_ON);
      break;
    case F1ReactionGameState.light_5:
      setLightState(false, false, L_5_ON);
      break;
      case F1ReactionGameState.lights_out:
        setLightState(false, false, ALL_OFF);
        break;
    default:
      setLightState(false, false, ALL_OFF);
    }

  }


  void setLightState(bool yellow, bool green, int red){
    List<int> masks = [0x10, 0x08, 0x04, 0x02, 0x01];
    for(int i =0; i< 5; i++){
      _lights[i][0] = yellow;
      _lights[i][1] = green;

      _lights[i][2] = masks[i] & red > 0;
      _lights[i][3] = masks[i] & red > 0;
    }
  }


  @override
  void paint(Canvas canvas, Size size) {
    applyState(_currentState.gameState);


    //TODO Draw screen
    Paint pB = Paint();
    pB..color = Colors.black;
    Paint pW = Paint();
    pW..color = Colors.white;



    canvas.drawRect(new Rect.fromLTWH(0, 0, size.width, size.height), pW);

    //canvas.drawCircle(Offset(50, 200), 50, p_r);
    for(int i = 0; i < 5; i++){
      canvas.drawRect(new Rect.fromLTWH(i * (_paddingWidth + 2 * _radius) + _diffTrafficLightWidth, _diffTrafficLightHeight, _paddingWidth + 2 * _radius - 2 * _diffTrafficLightWidth, size.height - 2 * _diffTrafficLightHeight), pB);
    }
    paintTrafficLights(canvas);
    if(_previousState == F1ReactionGameState.lights_out){
      _currentState.startStopwatch();
    }
  }

  void paintTrafficLights(Canvas canvas){
    for (int l = 0; l < 4; l++){
      for(int i = 0; i < 5; i++){
        this.paintSingleLight(canvas, i, l, _lights[i][l]);
      }
    }
  }



  void paintSingleLight(Canvas canvas, int x, int y, bool value){
    Paint pC = Paint();
    if(value){
      //light is on
      if(y == 0){
        //yellow light
        pC..color = Color.fromARGB(255, 246, 232, 13);
      }else if(y == 1){
        //green light
        pC..color = Color.fromARGB(255, 75, 244, 30);
      }else{
        //red light
        pC..color = Color.fromARGB(255, 240, 10, 10);
      }
    }else{
      //light is off
      if(y == 0){
        //yellow light
        pC..color = Color.fromARGB(255, 59, 54, 0);
      }else if(y == 1){
        //green light
        pC..color = Color.fromARGB(255, 18, 40, 21);
      }else{
        //red light
        pC..color = Color.fromARGB(255, 60, 0, 0);
      }
    }

    canvas.drawCircle(Offset((x * (2.0 * _radius + _paddingWidth) + 0.5 * _paddingWidth + _radius), (1 + y) *_paddingHeight + (1 + 2 * y) * _radius), _radius, pC);
  }


  @override
  bool shouldRepaint(covariant LightSystemPainter oldDelegate) {
    //if last drawn state and current state differ
    return oldDelegate._currentState.gameState != _previousState;
  }

}


class F1ReactionPostGameScreen extends StatelessWidget {
  static const routeName = '/games/f1-reaction-game/in-progress';
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
