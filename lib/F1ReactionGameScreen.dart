

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
}


class F1ReactionGameScreen extends StatefulWidget{
  static const routeName = '/games/f1-reaction-game/in-progress';


  
  @override
  State<StatefulWidget> createState() => _F1ReactionGameScreenState();

}

class _F1ReactionGameScreenState extends State<F1ReactionGameScreen>{
  F1ReactionGameState gameState = F1ReactionGameState.before_light_1;
  int millisecondsNextState;



  @override
  Widget build(BuildContext context) {
    _F1ReactionGameScreenState _curState = this;
    return Scaffold(body: Padding(
      padding: EdgeInsets.only(top: 50,),
      child: Column(
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
          ElevatedButton(onPressed: () => this.onPressedGoButton(context), child: Text('Go!')),
        ],
      ),
      ),

    );
  }
  void onPressedGoButton(BuildContext context){
    setState(() {
      gameState = F1ReactionGameState.light_1;
    });
  }
}

class LightSystemPainter extends CustomPainter{

  _F1ReactionGameScreenState _currentState;
  F1ReactionGameState _previousState;

  double _padding_width = 100;
  double _radius = 50;
  double _padding_height = 50;
  double _diff_traffic_light_width = 10;
  double _diff_traffic_light_height = 20;

  LightSystemPainter(this._currentState){
    _previousState = F1ReactionGameState.init;
  }



  @override
  void paint(Canvas canvas, Size size) {
    _previousState = _currentState.gameState;


    //TODO Draw screen
    Paint p_b = Paint();
    p_b..color = Colors.black;
    Paint p_w = Paint();
    p_w..color = Colors.white;
    Paint p_r = Paint();
    p_r..color = Colors.red;

    Paint p_y = Paint();
    p_y..color = Colors.yellow;

    Paint p_g = Paint();
    p_g..color = Colors.green;


    canvas.drawRect(new Rect.fromLTWH(0, 0, size.width, size.height), p_w);

    //canvas.drawCircle(Offset(50, 200), 50, p_r);
    for(int i = 0; i < 5; i++){
      canvas.drawRect(new Rect.fromLTWH(i * (_padding_width + 2 * _radius) + _diff_traffic_light_width, _diff_traffic_light_height, _padding_width + 2 * _radius - 2 * _diff_traffic_light_width, size.height - 2 * _diff_traffic_light_height), p_b);
    }

    for(int i = 0; i < 5; i++){
      //TODO, build memory for on/off for each field
      //TODO create method for drawCircle(x, y, on/off) --> dynamically assign correct color
      if(_previousState != F1ReactionGameState.light_1){
        canvas.drawCircle(Offset((i * (2.0 * _radius + _padding_width) + 0.5 * _padding_width + _radius), _padding_height + _radius), _radius, p_y);
      }


      canvas.drawCircle(Offset((i * (2.0 * _radius + _padding_width) + 0.5 * _padding_width + _radius), 2 *_padding_height + 3 * _radius), _radius, p_g);
      canvas.drawCircle(Offset((i * (2.0 * _radius + _padding_width) + 0.5 * _padding_width + _radius), 3 *_padding_height + 5 * _radius), _radius, p_r);
      canvas.drawCircle(Offset((i * (2.0 * _radius + _padding_width) + 0.5 * _padding_width + _radius), 4 *_padding_height + 7 * _radius), _radius, p_r);
    }
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
    
  }
}
