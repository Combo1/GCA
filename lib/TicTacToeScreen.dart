import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';

//------------------------ ParentWidget --------------------------------
class BoardWidget extends StatefulWidget {
  BoardWidget(this.bot);

  final bool bot;

  @override
  _BoardWidgetState createState() => _BoardWidgetState(bot);
}

class _BoardWidgetState extends State<BoardWidget> {
  _BoardWidgetState(this.bot);

  final bool bot;

  String _message() {
    switch (_state) {
      case 0:
        return "Turn of Player O";
      case 1:
        return "Turn of Player X";
      case 2:
        return "Player O wins! Restart?";
      case 3:
        return "Player X wins! Restart?";
      case 4:
        return "Draw! Restart?";
    }
  }

  void _showEndDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Game Over"),
          content: new Text(_message()),
          actions: <Widget>[
            new TextButton(
              child: new Text("Restart"),
              onPressed: () {
                _restart(_state);
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //bool _active = false;
  var _board = List.generate(
      3, (i) => List.generate(3, (j) => 0, growable: false),
      growable: false);
  int _state = 0;
  int _round = 0;
  Random _random = new Random();

  int _handleSelection(Tuple2<int, int> position) {
    if (_board[position.item1][position.item2] == 0 && _state < 2) {
      bool end = false;
      setState(() {
        _board[position.item1][position.item2] = _state + 1;
        _round++;
        for (int i = 0; i < 3; i++) {
          if (_board[i][1] != 0 &&
              _board[i][0] == _board[i][1] &&
              _board[i][1] == _board[i][2]) {
            end = true;
            _state = _board[i][0] + 1;
            break;
          } else if (_board[1][i] != 0 &&
              _board[0][i] == _board[1][i] &&
              _board[1][i] == _board[2][i]) {
            end = true;
            _state = _board[0][i] + 1;
            break;
          }
        }
        if (!end) {
          if (_board[1][1] != 0 &&
              ((_board[0][0] == _board[1][1] && _board[1][1] == _board[2][2]) ||
                  (_board[0][2] == _board[1][1] &&
                      _board[1][1] == _board[2][0]))) {
            _state = _board[1][1] + 1;
          } else {
            _state = (_round < 9) ? (_state + 1) % 2 : 4;
          }
        }
      });
    }
    return _state;
  }

  void _handleTapboxChanged(Tuple2<int, int> position) {
    if (_handleSelection(position) == 1 && bot) {
      Future.delayed(const Duration(milliseconds: 200), () {
        while (_handleSelection(
            Tuple2<int, int>(_random.nextInt(3), _random.nextInt(3))) == 1) {}
      });
    }
    if (_state > 1) _showEndDialog();
  }

  void _restart(int state) {
    setState(() {
      if (_state > 1) {
        _state = 0;
        _round = 0;
        for (int x = 0; x < 3; x++) {
          for (int y = 0; y < 3; y++) {
            _board[x][y] = 0;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        color: Colors.white,
        shadowColor: Colors.redAccent,
        child: Center(
          child: Text(
            _message(),
            style: TextStyle(fontSize: 32.0, color: Colors.black),
          ),
        ),
      ),
      Container(
          child: Column(children: [
            Row(children: [
              Tapbox(
                active: _board[0][0],
                onChanged: _handleTapboxChanged,
                position: Tuple2<int, int>(0, 0),
              ),
              Tapbox(
                active: _board[0][1],
                onChanged: _handleTapboxChanged,
                position: Tuple2<int, int>(0, 1),
              ),
              Tapbox(
                active: _board[0][2],
                onChanged: _handleTapboxChanged,
                position: Tuple2<int, int>(0, 2),
              ),
            ]),
            Row(children: [
              Tapbox(
                active: _board[1][0],
                onChanged: _handleTapboxChanged,
                position: Tuple2<int, int>(1, 0),
              ),
              Tapbox(
                active: _board[1][1],
                onChanged: _handleTapboxChanged,
                position: Tuple2<int, int>(1, 1),
              ),
              Tapbox(
                active: _board[1][2],
                onChanged: _handleTapboxChanged,
                position: Tuple2<int, int>(1, 2),
              ),
            ]),
            Row(children: [
              Tapbox(
                active: _board[2][0],
                onChanged: _handleTapboxChanged,
                position: Tuple2<int, int>(2, 0),
              ),
              Tapbox(
                active: _board[2][1],
                onChanged: _handleTapboxChanged,
                position: Tuple2<int, int>(2, 1),
              ),
              Tapbox(
                active: _board[2][2],
                onChanged: _handleTapboxChanged,
                position: Tuple2<int, int>(2, 2),
              ),
            ]),
          ]),
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
              )))
    ]);
  }
}

//------------------------- TapboxB ----------------------------------

class Tapbox extends StatelessWidget {
  Tapbox({Key key,
    this.active: 0,
    @required this.onChanged,
    @required this.position})
      : super(key: key);

  final int active;
  final ValueChanged<Tuple2<int, int>> onChanged;
  final Tuple2<int, int> position;

  void _handleTap() {
    onChanged(position);
  }

  String _buttonText() {
    if (active == 0) {
      return "";
    } else if (active == 1) {
      return "O";
    } else {
      return "X";
    }
  }

  Color _buttonColour() {
    if (active == 0) {
      return Colors.white;
    } else if (active == 1) {
      return Colors.lightGreen[700];
    } else {
      return Colors.red;
    }
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: _handleTap,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            child: Center(
              child: Text(
                _buttonText(),
                style: TextStyle(fontSize: 32.0, color: Colors.black),
              ),
            ),
            decoration: BoxDecoration(
                color: _buttonColour(),
                border: Border(
                  top: BorderSide(color: Colors.black),
                  left: BorderSide(color: Colors.black),
                )),
          ),
        ),
      ),
    );
  }
}

class TicTacToePVPScreen extends StatelessWidget {
  static const routeName = '/games/tictactoe/PVP';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe PVP'),
        backgroundColor: Color.fromRGBO(100, 32, 40, 1),
      ),
      body: Center(
        child: BoardWidget(false),
      ),
    );
  }
}

class TicTacToePVCScreen extends StatelessWidget {
  static const routeName = '/games/tictactoe/PVC';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe Computer'),
        backgroundColor: Color.fromRGBO(100, 32, 40, 1),
      ),
      body: Center(
        child: BoardWidget(true),
      ),
    );
  }
}

class TicTacToeScreen extends StatelessWidget {
  static const routeName = '/games/tictactoe';

  void onTicTacToePVPPressed(BuildContext context) {
    Navigator.pushNamed(context, TicTacToePVPScreen.routeName);
  }

  void onTicTacToePVCPressed(BuildContext context) {
    Navigator.pushNamed(context, TicTacToePVCScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        backgroundColor: Color.fromRGBO(100, 32, 40, 1),
      ),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              child: Center(child: Text('PVP')),
              onPressed: () => this.onTicTacToePVPPressed(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[900], // background
                onPrimary: Colors.white, // foreground
              ),
            ),
            Divider(),
            ElevatedButton(
              child: Center(child: Text('Computer')),
              onPressed: () => this.onTicTacToePVCPressed(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[900], // background
                onPrimary: Colors.white, // foreground
              ),
            ),
          ],
        ),
      ),
    );
  }
}
