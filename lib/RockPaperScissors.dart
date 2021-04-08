import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';

class RPSStandard extends StatefulWidget {
  @override
  _RPSStandardState createState() => _RPSStandardState();
}

Icon getIcon(int sign) {
  switch (sign) {
    case 0:
      return Icon(
        Icons.cut,
        color: Colors.black,
        size: 60.0,
      );
    case 1:
      return Icon(
        Icons.pan_tool,
        color: Colors.black,
        size: 60.0,
      );
    case 2:
      return Icon(
        Icons.cloud,
        color: Colors.black,
        size: 60.0,
      );
    default:
      return Icon(
        Icons.error,
        color: Colors.black,
        size: 60.0,
      );
  }
}

enum GameState { start, win, lose, draw }

class _RPSStandardState extends State<RPSStandard> {
  Random _random = new Random();

  void _handleButtonPressed(int sign) {
    if (_gameState == GameState.start) {
      setState(() {
        _buttonChoiceActivationList[sign] = true;
        _botChoice = _random.nextInt(3);
        if (_botChoice == sign)
          _gameState = GameState.draw;
        else if (_botChoice > sign) {
          if (_botChoice % 2 == sign % 2) {
            _winsBot++;
            _gameState = GameState.lose;
          } else {
            _winsHuman++;
            _gameState = GameState.win;
          }
        } else {
          if (_botChoice % 2 == sign % 2) {
            _winsHuman++;
            _gameState = GameState.win;
          } else {
            _winsBot++;
            _gameState = GameState.lose;
          }
        }
      });
    }
  }

  void _gameStatePressed() {
    if (_gameState != GameState.start) {
      setState(() {
        _gameState = GameState.start;
        for (int i = 0; i < _buttonChoiceActivationList.length; i++) {
          _buttonChoiceActivationList[i] = false;
          _botChoice = 100;
        }
      });
    }
  }

  String _gameStateToText() {
    switch (_gameState) {
      case GameState.start:
        return "Make your Choice!";
        break;
      case GameState.win:
        return "You won!";
        break;
      case GameState.lose:
        return "You lost!";
        break;
      case GameState.draw:
        return "Draw!";
        break;
    }
  }

  int _winsBot = 0;
  int _winsHuman = 0;
  int _botChoice = 100;
  GameState _gameState = GameState.start;
  List<bool> _buttonChoiceActivationList =
      List.generate(3, (j) => false, growable: false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: BotChoice(sign: _botChoice)),
        Center(
            child: TextButton(
                child: Text(_gameStateToText(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
                onPressed: _gameStatePressed)),
        Card(
          child: Row(
            children: [
              Spacer(flex: 8),
              Center(
                  child: Text(
                _winsBot.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              )),
              Spacer(flex: 1),
              Center(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              )),
              Spacer(flex: 1),
              Center(
                  child: Text(
                _winsHuman.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              )),
              Spacer(flex: 8)
            ],
          ),
        ),
        Row(
          children: [
            Button(
                sign: 0,
                active: _buttonChoiceActivationList[0],
                onChanged: _handleButtonPressed),
            Button(
                sign: 1,
                active: _buttonChoiceActivationList[1],
                onChanged: _handleButtonPressed),
            Button(
                sign: 2,
                active: _buttonChoiceActivationList[2],
                onChanged: _handleButtonPressed),
          ],
        )
      ],
    );
  }
}

class BotChoice extends StatelessWidget {
  BotChoice({Key key, this.sign: 0}) : super(key: key);
  final int sign;

  @override
  Widget build(BuildContext context) {
    return getIcon(sign);
  }
}

class Button extends StatelessWidget {
  Button(
      {Key key, this.sign: 0, @required this.active, @required this.onChanged})
      : super(key: key);

  final int sign;
  final ValueChanged<int> onChanged;
  final bool active;

  void _handleTap() {
    onChanged(sign);
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: active ? Color.fromRGBO(100, 32, 40, 1) : Colors.white)),
            child: getIcon(sign)),
      ),
    );
  }
}

class RPSStandardScreen extends StatelessWidget {
  static const routeName = '/games/rps/standard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rock Paper Scissor Standard'),
        backgroundColor: Color.fromRGBO(100, 32, 40, 1),
      ),
      body: Center(
        child: RPSStandard(),
      ),
    );
  }
}

class RPSScreen extends StatelessWidget {
  static const routeName = '/games/rps';

  void onStandardPressed(BuildContext context) {
    Navigator.pushNamed(context, RPSStandardScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rock Paper Scissor'),
        backgroundColor: Color.fromRGBO(100, 32, 40, 1),
      ),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              child: Center(child: Text('Standard')),
              onPressed: () => this.onStandardPressed(context),
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
