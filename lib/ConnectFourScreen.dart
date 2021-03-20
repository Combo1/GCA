
import 'package:flutter/material.dart';

class ConnectFourScreen extends StatefulWidget{
  static const routeName = '/games/connectfour';

  @override
  _ConnectFourScreenState createState() => _ConnectFourScreenState();
}

class _ConnectFourScreenState extends State<ConnectFourScreen> {
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

    void playGame(int row, int column) {
      if(this.list1[row][column] == -1) {
        setState(() {
          if(myturn) {
            list1[row][column] = 0;
          } else {
            list1[row][column] = 1;
          }
          myturn = !myturn;
        });
      }
    }

    IconButton get_Icon(state, row, column) {
      switch(state) {
        case -1: {
          return IconButton(
              iconSize: 25,
              icon: Icon(Icons.add_circle_outline), onPressed: () {
            playGame(row, column);
          }
          );
        }
        break;
        case 0: {
          return IconButton(iconSize: 25,icon: Icon(Icons.ac_unit), onPressed: () {});
        }
        break;
        case 1: {
          return IconButton(iconSize: 25,icon: Icon(Icons.access_alarm), onPressed: () {});
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
                    Text("It is player's " + myturn.toString() + " turn.", style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                  ])),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*Card(
              child: Text("It is player " + myturn.toString() + " turn."),
          ), */
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