import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';

class RPSStandard extends StatefulWidget {
  @override
  _RPSStandardState createState() => _RPSStandardState();
}

class _RPSStandardState extends State<RPSStandard> {
  void _handleButtonPressed(int sign) {

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Icon(
          Icons.cut,
          color: Colors.black,
          size: 40.0,
        )),
        Row(
          children: [
            Button(sign: 0, onChanged: _handleButtonPressed),
            Button(sign: 1, onChanged: _handleButtonPressed),
            Button(sign: 2, onChanged: _handleButtonPressed),
          ],
        )
      ],
    );
  }
}

class Button extends StatelessWidget {
  Button({Key key, this.sign: 0, @required this.onChanged}) : super(key: key);

  final int sign;
  final ValueChanged<int> onChanged;

  void _handleTap() {
    onChanged(sign);
  }

  Icon getIcon() {
    switch (sign) {
      case 0:
        return Icon(
          Icons.cut,
          color: Colors.black,
          size: 40.0,
        );
      case 1:
        return Icon(
          Icons.pan_tool,
          color: Colors.black,
          size: 40.0,
        );
      case 2:
        return Icon(
          Icons.cloud,
          color: Colors.black,
          size: 40.0,
        );
      default:
        return Icon(
          Icons.error,
          color: Colors.black,
          size: 40.0,
        );
    }
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(onTap: _handleTap, child: getIcon()),
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
