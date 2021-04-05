import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';



class ConnectFourScreen extends StatelessWidget{
  static const routeName = '/games/tictactoe';


  void onTicTacToePVPPressed(BuildContext context){
    Navigator.pushNamed(context, ConnectFourPVPScreen.routeName);
  }

  void onTicTacToePVCPressed(BuildContext context){
    Navigator.pushNamed(context, ConnectFourPVCScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
        ),
        body: Center(
          child: ListView(
            children: [
              ElevatedButton(child: Center(child: Text('PVP')), onPressed: () => this.onTicTacToePVPPressed(context), ),
              Divider(),
              ElevatedButton(child: Center(child: Text('Computer')), onPressed: () => this.onTicTacToePVCPressed(context), ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectFourPVCScreen extends StatelessWidget{
  static const routeName = '/games/connectfour/PVC';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Four Computer',
    );
  }
}


class ConnectFourPVPScreen extends StatefulWidget{
  static const routeName = '/games/connectfour/PVP';

  @override
  _ConnectFourScreenState createState() => _ConnectFourScreenState();
}

class _ConnectFourScreenState extends State<ConnectFourPVPScreen> {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  bool _hasBeenPressed = false;
  var list1 = [[-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1]];
  var myturn = true;


  @override
  Widget build(BuildContext context) {
    AssetImage cross = AssetImage("images/cross.png");
    AssetImage circle = AssetImage("images/circle.png");
    AssetImage edit = AssetImage("images/edit.png");

    AudioCache _audioCache = AudioCache(prefix: 'assets/Audio/');


    bool checkWin(row, column, myturn) {
      //row: Column of last placed token
      //Column: Row of last placed token
      //player: 0 or 1 depended on which played placed the last token
      int player = myturn? 0 : 1;
      int count = 0;

      //Vertical Check

      for(int i = 0; i < 6; i++) {
        if(list1[row][i] == player) {
          count++;
        } else {
          count=0;
        }
        if(count>= 4) {
          return true;
        }
      }


      count = 0;
      //Horizontal Check
      for(int i = 0; i < 7 ; i++) {
        if(list1[i][column] == player) {
          count++;
        } else {
          count = 0;
        }

        if(count>= 4) {
          return true;
        }
      }
      count = 0;

      //Top-left to Bottom-right

      for(int i = 1; i < 4; i++) {
        count = 0;
        for(int r = i, c = 0; r < 7 && c < 6; r++, c++) {
          if(list1[r][c] == player) {
            count++;
            if(count >= 4) {
              return true;
            }
          }
          else {
            count = 0;
          }
        }
      }
      for(int i = 0; i < 3; i++) {
        count = 0;
        for(int r = 0, c = i; r < 7 && c < 6; r++, c++) {
          if(list1[r][c] == player) {
            count++;
            if (count >= 4) {
              return true;
            }
          }
          else {
            count = 0;
          }
        }
      }

      //Left-Bottom to Top-Right
      for(int i = 3; i < 6; i++) {
        count = 0;
        for(int r = 0, c = i; r < 7 && c > -1; r++, c--) {
          if(list1[r][c] == player) {
            count++;
            if(count >= 4) {
              return true;
            }
          } else {
            count = 0;
          }
        }
      }

      for(int i = 1; i < 4; i++) {
        count = 0;
        for(int r = i, c = 5; r < 7 && c > -1; r++, c--) {
          if(list1[r][c] == player) {
            count++;
            if(count >= 4) {
              return true;
            }
          } else {
            count = 0;
          }
        }
      }

      return false;
    }

    //column = 0 = top
    //row = 0 = left
    int findFirstEmptyRow(row) {
      for(int i = 5; i > -1; i--) {
        if(list1[row][i] == -1) {
          return i;
        }
      }
      return -1;
    }

    void playGame(int row, int column) {
      if(this.list1[row][column] == -1) {
        setState(() {
          if(myturn) {
            //print(row);
            //print(column);
            list1[row][findFirstEmptyRow(row)] = 0;
          } else {
            list1[row][findFirstEmptyRow(row)] = 1;
          }
        });
      }
    }

    _showDialog(winner) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Player ' + (myturn?"red":"blue") + ' won!'),
            actions:<Widget> [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      list1 = [[-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1], [-1, -1, -1, -1, -1, -1]];
                    });
                  },
                  child: Text('Reset Game'),
              ),
            ]
          );
        }
      );
    }




    IconButton get_Icon(state, row, column) {
      switch(state) {
        case -1: {
          return IconButton(
              iconSize: 32,
              icon: Icon(Icons.add_circle_outline), onPressed: () {
                _audioCache.play('zapsplat_foley_stones_pebbles_few_place_down_001.mp3');
                playGame(row, column);
                if(checkWin(row, findFirstEmptyRow(row)+1, myturn)) {
                  _showDialog(myturn);
                  }
                myturn = !myturn;
              }
          );
        }
        break;
        case 0: {
          return IconButton(iconSize: 32,color: Colors.blue, icon: Icon(Icons.circle), onPressed: () {});
        }
        break;
        case 1: {
          return IconButton(iconSize: 32, color: Colors.red, icon: Icon(Icons.circle), onPressed: () {});
        }
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Vier gewinnt'),
          centerTitle: true,
          backgroundColor: Colors.blue[600],
        ),

        backgroundColor: Colors.white,
        body: Container(
            child:Column(

                children: <Widget> [
                  Card(margin: EdgeInsets.fromLTRB(16, 16, 16, 16), child: Column(children: <Widget> [
                    Text("It is player's " + (myturn?"blue":"red") + " turn.", style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                  ])),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          children: <Widget> [get_Icon(list1[0][0], 0, 0),
                            get_Icon(list1[0][1], 0, 1),
                            get_Icon(list1[0][2], 0, 2),
                            get_Icon(list1[0][3], 0, 3),
                            get_Icon(list1[0][4], 0, 4),
                            get_Icon(list1[0][5], 0, 5),
                          ]
                        //list1[0].map((state) => get_Icon(state)).toList(),
                      ), Column(
                          children: <Widget> [get_Icon(list1[1][0], 1, 0),
                            get_Icon(list1[1][1], 1, 1),
                            get_Icon(list1[1][2], 1, 2),
                            get_Icon(list1[1][3], 1, 3),
                            get_Icon(list1[1][4], 1, 4),
                            get_Icon(list1[1][5], 1, 5),
                          ]

                        //list1[1].map((state) => get_Icon(state)).toList(),
                      ), Column(
                          children:
                          <Widget> [get_Icon(list1[2][0], 2, 0),
                            get_Icon(list1[2][1], 2, 1),
                            get_Icon(list1[2][2], 2, 2),
                            get_Icon(list1[2][3], 2, 3),
                            get_Icon(list1[2][4], 2, 4),
                            get_Icon(list1[2][5], 2, 5),
                          ]
                        //list1[2].map((state) => get_Icon(state)).toList(),
                      ), Column(
                          children:
                          <Widget> [get_Icon(list1[3][0], 3, 0),
                            get_Icon(list1[3][1], 3, 1),
                            get_Icon(list1[3][2], 3, 2),
                            get_Icon(list1[3][3], 3, 3),
                            get_Icon(list1[3][4], 3, 4),
                            get_Icon(list1[3][5], 3, 5),
                          ]
                        //list1[3].map((state) => get_Icon(state)).toList(),
                      ), Column(
                          children:
                          <Widget> [get_Icon(list1[4][0], 4, 0),
                            get_Icon(list1[4][1], 4, 1),
                            get_Icon(list1[4][2], 4, 2),
                            get_Icon(list1[4][3], 4, 3),
                            get_Icon(list1[4][4], 4, 4),
                            get_Icon(list1[4][5], 4, 5),
                          ]
                        //list1[4].map((state) => get_Icon(state)).toList(),
                      ), Column(
                          children:
                          <Widget> [get_Icon(list1[5][0], 5, 0),
                            get_Icon(list1[5][1], 5, 1),
                            get_Icon(list1[5][2], 5, 2),
                            get_Icon(list1[5][3], 5, 3),
                            get_Icon(list1[5][4], 5, 4),
                            get_Icon(list1[5][5], 5, 5),
                          ]
                        //list1[5].map((state) => get_Icon(state)).toList(),
                      ), Column(
                          children:
                          <Widget> [get_Icon(list1[6][0], 6, 0),
                            get_Icon(list1[6][1], 6, 1),
                            get_Icon(list1[6][2], 6, 2),
                            get_Icon(list1[6][3], 6, 3),
                            get_Icon(list1[6][4], 6, 4),
                            get_Icon(list1[6][5], 6, 5),
                          ]
                        //list1[6].map((state) => get_Icon(state)).toList(),
                      ),],
                  )
                ]
            )
        )
    );
  }
}