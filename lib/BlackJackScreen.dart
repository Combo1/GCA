import 'package:flutter/material.dart';

class BlackJackScreen extends StatefulWidget {
  BlackJackScreen({Key key, this.title}) : super(key: key);

  static const routeName = '/games/black-jack';

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
  var _drawnCards = [];

  void _drawNextCard() {
    setState(() {
      BJCard nextCard = cardDeck.getNext();
      _drawnCards.add(nextCard);
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

  String getCardsText(){
    String s = '';
    for(BJCard card in _drawnCards){
      var suit = card.suit;

      switch(suit){
        case(BJCardSuits.clubs): s+='\u2663'; break;
        case(BJCardSuits.diamonds): s+='\u2666'; break;
        case(BJCardSuits.hearts): s+='\u2665'; break;
        case(BJCardSuits.spades): s+='\u2660'; break;
      }

      int num = card.num;

      if(num <= 10){
        s += num.toString();
      }
      else{
        switch(num){
          case(11): s+='A'; break;
          case(12): s+='J'; break;
          case(13): s+='Q'; break;
          case(14): s+='K'; break;
        }
      }

      s+=' ';
    }
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
              getCardsText(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              getScoreText(),
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