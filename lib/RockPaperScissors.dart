import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';

class RPSStandard extends StatefulWidget {
  @override
  _RPSStandardState createState() => _RPSStandardState();
}

class _RPSStandardState extends State<RPSStandard> {
  @override
  Widget build(BuildContext context) {
    return Container();
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