import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AntWarsScreen extends StatefulWidget {
  static const routeName = '/games/antwars';

  @override
  State<StatefulWidget> createState() => _AntWarsScreen();

}

class _AntWarsScreen extends State<AntWarsScreen> {
  //Blue Tap, red Double Tap
  Color current_color = Colors.red[600];
  Color firstColor = Colors.blue[600];
  Color secondColor = Colors.red[600];
  Color thirdColor = Colors.green[600];
  Color fourthColor = Colors.yellow[600];
  Color fifthColor = Colors.blueGrey[600];
  //When introducing new colors put them into the list too!

  var colorList = [Colors.blue[600], Colors.red[600], Colors.green[600], Colors.yellow[600], Colors.blueGrey[600]];

  Random _random = Random();
  int score = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Ant Wars'),
          centerTitle: true,
          backgroundColor: Colors.blue[600],
        ),
        body: _buildGameContent(context)
    );
  }

  Widget _buildGameContent(BuildContext context) {
    return Container(
        color: current_color,
        child: Stack(
          children: [
            Center(child: Text('Score: ${score}' , style: const TextStyle(fontSize: 30))),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (current_color == firstColor) {
                    current_color = _getRandomColor();
                    score++;
                  }
                });
              },
              onDoubleTap: () {
                setState(() {
                  if (current_color == secondColor) {
                    current_color = _getRandomColor();
                    score++;
                  }
                });
              },
              onLongPress: () {
                setState(() {
                  if (current_color == thirdColor) {
                    current_color = _getRandomColor();
                    score++;
                  }
                });
              },
              onHorizontalDragStart: (DragStartDetails details) {
                setState(() {
                  if (current_color == fourthColor) {
                    current_color = _getRandomColor();
                    score++;
                  }
                });
              },
              onVerticalDragStart: (DragStartDetails details) {
                setState(() {
                  if (current_color == fifthColor) {
                    current_color = _getRandomColor();
                    score++;
                  }
                });
              },
            )
          ],
        )
    );
  }

  //Auxiliary methods
  Color _getRandomColor() {
    int index = _random.nextInt(colorList.length);
    return colorList[index];
  }


}



