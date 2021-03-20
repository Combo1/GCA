

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


class F1ReactionGameScreen extends StatefulWidget{
  static const routeName = '/games/f1-reaction-game/in-progress';
  
  
  @override
  State<StatefulWidget> createState() => _F1ReactionGameScreenState();

}

class _F1ReactionGameScreenState extends State<F1ReactionGameScreen>{
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
}


class F1ReactionPostGameScreen extends StatelessWidget {
  static const routeName = '/games/f1-reaction-game/in-progress';
  @override
  Widget build(BuildContext context) {
    
  }
}
