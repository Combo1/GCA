import 'package:flutter/material.dart';

class BlackJackScreen extends StatefulWidget {
  BlackJackScreen({Key key, this.title}) : super(key: key);

  final String title;
  BJCardDeck cardDeck = new BJCardDeck();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BlackJackScreen> {
  var _counter = [0];
  BJCardDeck cardDeck = new BJCardDeck();
  int _hasAce = 0;
  bool _gameOver = false;

  void _drawNextCard() {
    setState(() {
      BJCard nextCard = cardDeck.getNext();
      if(nextCard.num == 11){
        _hasAce++;
      }

      for (int i in _counter){
        i += nextCard.num;

        if(i > 21) {
          _counter.remove(i);
          if(_hasAce == 0) {
            _gameOver = true;
          }
        }
      }
    });
  }

  String getScoreText(){
    if(_gameOver){
      return 'Game Over';
    }
    else{
      return 'Current score: ' + _counter.toString();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              getScoreText(),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _drawNextCard,
        tooltip: 'Draw Card',
        label: const Text("Draw next"),
        icon: const Icon(Icons.add_to_photos),
      ),
    );
  }
}

enum BJCardSuits{
  clubs,
  diamonds,
  hearts,
  spades
}

class BJCard{
  BJCardSuits suit;
  int num;

  BJCard(BJCardSuits suit, int num){
    suit = suit;
    num = num;
  }
}

class BJCardDeck{
  var _cardDeck = [];

  BJCardDeck(){
    for (int i = 1; i<= 14; i++){
      // because ace is both 1 and 11
      if(i != 11){
        for(var j in BJCardSuits.values){
          _cardDeck.add(new BJCard(j, i));
        }
      }
    }
    _cardDeck.shuffle();
  }

  BJCard getNext(){
    BJCard next = _cardDeck.last;
    _cardDeck.removeLast();

    return next;
  }
}