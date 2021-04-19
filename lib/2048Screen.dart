
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gca/StatisticConfig.dart';
import 'package:gca/StatisticsModel.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Game2048Screen extends StatefulWidget{
  static const routeName = '/games/2048';

  @override
  State<StatefulWidget> createState() {
    return _Game2048State();
  }

}

enum Animation2048State{
  FIXED_POSITION, MOVING, APPEARING,
}

enum _Direction{
  LEFT, RIGHT, UP, DOWN,
}


class _Game2048State extends State<Game2048Screen> with TickerProviderStateMixin{

  final int rowSize;
  final int columnSize;
  int totalSize;
  bool isGameRunning = true;

  //game stats
  List<int> values;
  List<int> valuesAfter;
  List<bool> isAppearing;
  List<int> targetID;
  int _score = 0;

  bool _isInAnimation = false;
  bool _requireTextUpdate = false;

  //for swiping
  bool _isHorizontal = false;
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  String _resultSwipe = '';
  Random _random = Random();
  //for the animation
  Animation2048State _currentState = Animation2048State.FIXED_POSITION;


  //animation attributes for appearing animation
  Animation<double> animationAppearing;
  AnimationController controllerAppearing;
  Tween<double> _animationAppearingTween = Tween(begin: 0.5, end: 1.0);
  //abnimation attributes for moving animation
  Animation<double> animationMoving;
  AnimationController controllerMoving;
  Tween<double> _animationMovingTween = Tween(begin: 0.0, end: 1.0);

  _Game2048State({this.rowSize = 4, this.columnSize = 4}){
    totalSize = rowSize * columnSize;
    values = List.filled(totalSize, 0);
    isAppearing = List.filled(totalSize, false);
    valuesAfter = List.filled(totalSize, 0);
    targetID = List.filled(totalSize, 0);
    initGame();
  }


  int toIndexX(int id){
    return id % rowSize;
  }
  int toIndexY(int id){
    return id ~/ rowSize;
  }

  int toIndex(int indexX, int indexY){
    return indexX + indexY * columnSize;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);//force potrait mode in this mode

    //animation appearing
    controllerAppearing = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    animationAppearing = _animationAppearingTween.animate(controllerAppearing)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllerAppearing.stop();
          this.stopTimerAppearing();
        } else if (status == AnimationStatus.dismissed) {
          controllerAppearing.stop();
        }
      });

    startTimerAppearing();
    //animation moving
    controllerMoving = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    animationMoving = _animationMovingTween.animate(controllerMoving)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllerMoving.stop();
          this.stopTimerMoving();
        } else if (status == AnimationStatus.dismissed) {
          controllerMoving.stop();
        }
      });
  }

  void saveState(){
    if(isGameRunning){

      //save size, score and values
      String saveGame = "$columnSize;$rowSize;$_score;" + values.join(',');
      Provider.of<StatisticsModel>(context, listen: false).setValue(StatConst.KEY_GAME_2048, StatConst.KEY_SAVEGAME_1, saveGame);
    }
    //save moves done
    String movesDone = Provider.of<StatisticsModel>(context, listen: false).getValue(StatConst.KEY_GAME_2048, StatConst.KEY_MOVES_PERFORMED);
    //TODO update value here
    Provider.of<StatisticsModel>(context, listen: false).setValue(StatConst.KEY_GAME_2048, StatConst.KEY_MOVES_PERFORMED, movesDone);
    print('Saved state');
  }


  @override
  void dispose() {
    controllerAppearing.dispose();
    controllerMoving.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight,]);//force potrait mode in this mode
    //save current game, if game is running

    saveState();
    super.dispose();
  }

  void initGame(){
    //choose two random fields, set both values to appearing
    Tuple2 result = placeRandomTile(values, amount: 2);
    values = result.item1;
    isAppearing = result.item2;
    _isInAnimation = true;
    _currentState = Animation2048State.APPEARING;
    _requireTextUpdate = true;
  }

  void startTimerAppearing(){
    controllerAppearing.reset();
    controllerAppearing.forward();

    //print('start appearing');
    setState(() {
      _isInAnimation = true;
      _currentState = Animation2048State.APPEARING;
    });

  }

  void stopTimerAppearing(){

    //print('Stop appearing');
    setState(() {
      _isInAnimation = false;
      _currentState = Animation2048State.FIXED_POSITION;
    });
  }

  void startTimerMoving(){
    //print('start moving');
    controllerMoving.reset();
    controllerMoving.forward();

    setState(() {
      _isInAnimation = true;
      _currentState = Animation2048State.MOVING;
    });
  }

  void stopTimerMoving(){
    //print('Stop Moving');
    setState(() {
      values = valuesAfter;
      _isInAnimation = false;
    });

    startTimerAppearing();


  }

  //manipulates valuesAfter and isAppearing
  //only call after moveTiles
  Tuple2 placeRandomTile(List<int> currentState, {int amount = 1}){
    List<int> nextState = List.filled(totalSize, 0);
    List<bool> isAppearing = List.filled(totalSize, false);
    print('State after moving: $currentState');
    List.copyRange(nextState, 0, currentState);
    if(amount <= 0){
      amount = 1;
    }
    //find valid positions for new values
    List<int> listValidID = [];
    for(int i = 0; i < totalSize; i++){
      if(currentState[i] == 0){
        listValidID.add(i);
      }
    }
    //place new tiles on empty fields (amount of new tiles specified in input parameter)
    for(int i = 0; i< amount && listValidID.isNotEmpty; i++){
      int chosenIndexInList = _random.nextInt(listValidID.length);
      int chosenID = listValidID[chosenIndexInList];
      int randomValue = _random.nextBool() ? 2 : 4;
      //update values for animation
      nextState[chosenID] = randomValue;
      isAppearing[chosenID] = true;
      //remove chosen ID from list
      listValidID.removeAt(chosenIndexInList);
    }
    print('Next State: $nextState');
    return Tuple2(nextState, isAppearing);
  }

  //create new valuesAfterList and call placeNewTile() afterwards
  //later, check for game over event
  void moveTilesEvent(_Direction x){
    //if move did not change tiles, then mark move as invalid
    Tuple4 nextState = getNextState(x, values);
    //check if moved, dont apply next state if state didn't change
    if(isSameState(values, nextState.item1)){
      print('no change occured, IsGameActive: $isGameRunning');
      return;
    }else{
      print('change has occured');
      //continue and apply event changes
      print('Target: ${nextState.item2}');
      targetID = nextState.item2;
      _score += nextState.item4;
      //add new random tile to state
      Tuple2 stateAfterPlacement = placeRandomTile(nextState.item1);
      valuesAfter = stateAfterPlacement.item1;
      isAppearing = stateAfterPlacement.item2;
      for(int i = 0; i < isAppearing.length; i++){
        isAppearing[i] = isAppearing[i] || nextState.item3[i];
      }
      //check possible game over state
      if(isGameOver(valuesAfter)){
        //print('Game Over discovered');

        setGameOver();
      }
      startTimerMoving();
    }
  }

  void setGameOver(){
    isGameRunning = false;
    //save stats
    String strGames = Provider.of<StatisticsModel>(context, listen: false).getValue(StatConst.KEY_GAME_2048, StatConst.KEY_AMOUNT_GAMES);
    String strHighscore = Provider.of<StatisticsModel>(context, listen: false).getValue(StatConst.KEY_GAME_2048, StatConst.KEY_PERSONAL_BEST);
    int games = int.parse(strGames) + 1;
    //TODO set flag for new record here
    int highscore = max(int.parse(strHighscore), _score);
    Provider.of<StatisticsModel>(context, listen: false).setValue(StatConst.KEY_GAME_2048, StatConst.KEY_AMOUNT_GAMES, "$games");
    Provider.of<StatisticsModel>(context, listen: false).setValue(StatConst.KEY_GAME_2048, StatConst.KEY_PERSONAL_BEST, "$highscore");
    Provider.of<StatisticsModel>(context, listen: false).setValue(StatConst.KEY_GAME_2048, StatConst.KEY_SAVEGAME_1, "");//delete existing savegame
  }


  //applies swipe on current state and returns changes
  Tuple4 getNextState(_Direction x, List<int> currentState){
    List<int> stateAfter = List.filled(totalSize, 0);
    List<int> targetID = List.filled(totalSize, 0);
    List<bool> hasMerged = List.filled(totalSize, false);
    int _scoreIncrease = 0;
    //TODO combine vertical and horizontal procedure
    if(x == _Direction.DOWN || x == _Direction.UP){
      //manipulate all entries in the same column
      for(int i = 0; i < columnSize; i++){
        int indexMarker = 0;//marker on next free tile or a value greater than zero and merge potential
        int step = 1;
        int startIndex = 0;
        if(x == _Direction.DOWN){
          indexMarker = rowSize - 1;
          startIndex = rowSize -1;
          step = -1;
        }
        for(int l = startIndex; l >= 0 && l < rowSize; l += step){
          //move current index tile to next free position, either a free field or merge with existing value
          if(currentState[toIndex(i, l)] != 0){
            if(stateAfter[toIndex(i, indexMarker)] == 0){
              //free field, fill up
              stateAfter[toIndex(i, indexMarker)] = currentState[toIndex(i, l)];
              targetID[toIndex(i, l)] = toIndex(i, indexMarker); //remember movement l --> indexMarker
            }else if(stateAfter[toIndex(i, indexMarker)] == currentState[toIndex(i, l)]){
              //mergable field and current value can merge, move indexMarker to next field
              print('Merge possible');
              stateAfter[toIndex(i, indexMarker)] = 2 * stateAfter[toIndex(i, indexMarker)]; //double value
              _scoreIncrease += stateAfter[toIndex(i, indexMarker)]; //add value to scoreIncrease
              targetID[toIndex(i, l)] = toIndex(i, indexMarker);
              hasMerged[toIndex(i, indexMarker)] = true; //this value is a merged value
              indexMarker += step;
            }else{
              //values are not the same, use the next free tile
              indexMarker += step;
              stateAfter[toIndex(i, indexMarker)] = currentState[toIndex(i, l)];
              targetID[toIndex(i, l)] = toIndex(i, indexMarker); //remember movement l --> indexMarker
            }
          }

        }

      }
    }else{
      //left or right
      //manipulate all entries in the same row
      for(int l = 0; l < rowSize; l++){
        int indexMarker = 0;//marker on next free tile or a value greater than zero and merge potential
        int step = 1;
        int startIndex = 0;
        if(x == _Direction.RIGHT){
          indexMarker = columnSize - 1;
          startIndex = columnSize -1;
          step = -1;
        }
        for(int i = startIndex; i >= 0 && i < columnSize; i += step){
          //move current index tile to next free position, either a free field or merge with existing value
          if(currentState[toIndex(i, l)] != 0){
            if(stateAfter[toIndex(indexMarker, l)] == 0){
              //free field, fill up
              stateAfter[toIndex(indexMarker, l)] = currentState[toIndex(i, l)];
              targetID[toIndex(i, l)] = toIndex(indexMarker, l); //remember movement l --> indexMarker
            }else if(stateAfter[toIndex(indexMarker, l)] == currentState[toIndex(i, l)]){
              //mergable field and current value can merge, move indexMarker to next field
              //print('Merge possible');
              stateAfter[toIndex(indexMarker, l)] = 2 * stateAfter[toIndex(indexMarker, l)]; //double value
              _scoreIncrease += stateAfter[toIndex(indexMarker, l)]; //add value to scoreIncrease
              targetID[toIndex(i, l)] = toIndex(indexMarker, l);
              hasMerged[toIndex(indexMarker, l)] = true; //this value is a merged value
              indexMarker += step;
            }else{
              //values are not the same, use the next free tile
              indexMarker += step;
              stateAfter[toIndex(indexMarker, l)] = currentState[toIndex(i, l)];
              targetID[toIndex(i, l)] = toIndex(indexMarker, l); //remember movement l --> indexMarker
            }
          }
        }
      }
    }
    return Tuple4(stateAfter, targetID, hasMerged, _scoreIncrease);
  }

  //compares two states on equal values
  bool isSameState(List<int> currentState, List<int> nextState){
    if(currentState.length != nextState.length){
      print('not same length');
      return false;
    }else{
      for(int i = 0; i < currentState.length; i++){
        if(currentState[i] != nextState[i]){
          return false;
        }
      }
      return true;
    }
  }

  bool isGameOver(List<int> state){
    //either a 0 is on a tile or two identical next to each other means no game over
    bool hasFieldZero = state.any((element) => element == 0);
    if(!hasFieldZero){
      //check identical values in each row
      for(int l = 0; l < rowSize; l++) {
        int val = state[toIndex(0, l)];//first value in row
        for (int i = 1; i < columnSize; i++) {
          if(state[toIndex(i, l)] == val){
            //same value, return false
            //print('two same values discovered (same row): $i, $l');
            return false;
          }else{
            val = state[toIndex(i, l)];
          }
        }
      }
      //check identical values in each column
      for (int i = 0; i < columnSize; i++) {
        int val = state[toIndex(i, 0)];//first value in column
        for(int l = 1; l < rowSize; l++) {
          if(state[toIndex(i, l)] == val){
            //print('two same values discovered (same column): $i, $l');
            return false;//same value, return false
          }else{
            val = state[toIndex(i, l)];
          }
        }
      }
      return true;
    }else{
      //print('Zero discovered');
      return false;//at least one empty field available
    }

  }

  void onHorizontalDragEnd(DragEndDetails e){
    if(_offsetX > 0){
      //swipe right
      setState(() {
        _resultSwipe = 'right';
      });
      moveTilesEvent(_Direction.RIGHT);
    }else if(_offsetX < 0){
      setState(() {
        _resultSwipe = 'left';
      });
      moveTilesEvent(_Direction.LEFT);
    }

  }
  void onVerticalDragEnd(DragEndDetails e){
    if(_offsetY > 0){
      //swipe right
      setState(() {
        _resultSwipe = 'bottom';
        moveTilesEvent(_Direction.DOWN);
      });
    }else if(_offsetY < 0){
      setState(() {
        _resultSwipe = 'up';
        moveTilesEvent(_Direction.UP);
      });
    }
  }

  void onVerticalDragStart(DragStartDetails e){
    _isHorizontal = false;
    _offsetX = 0;
    _offsetY = 0;
  }

  void onDragUpdate(String type, DragUpdateDetails e){
    _offsetX += e.delta.dx;
    _offsetY += e.delta.dy;
  }

  void onHorizontalDragStart(DragStartDetails e){
    _isHorizontal = true;
    _offsetX = 0;
    _offsetY = 0;
  }


  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: (){
          //method saves progress when pressing the back button and returns to the previous screen
          this.saveState();
          Navigator.pop(context);
          return Future.value(false);
          },
        child:
      Scaffold(
        body: Container(
          color: Colors.amber,
          child: SafeArea(child:
        GestureDetector(
          onHorizontalDragEnd: (e) => this.onHorizontalDragEnd(e),
          onVerticalDragEnd: (e) => this.onVerticalDragEnd(e),
          onHorizontalDragUpdate: (e) => this.onDragUpdate('Horizontal', e),
          onVerticalDragUpdate: (e) => this.onDragUpdate('Vertical: ', e),
          onHorizontalDragStart: (e) => this.onHorizontalDragStart(e),
          onVerticalDragStart: (e) => this.onVerticalDragStart(e),
            child: Column(
              children: [
              Padding(
                padding: EdgeInsets.only(bottom: 50, top: 50),
                child: Text('Score: $_score, $_resultSwipe,', style: TextStyle(fontSize: 40)),
              ),
              Text('$_currentState,', style: TextStyle(fontSize: 20)),
              FittedBox(alignment: Alignment.center, fit: BoxFit.fitWidth, child:
                SizedBox.fromSize(
                    size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                    child: CustomPaint(painter: Game2048CustomPainter(this)
                    ),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
          ),
      ),
      ),
      ),
    );
  }
  Widget _buildBottomButtons(){
    if(isGameRunning && false){
      return Container();
    }
    return
      Padding(padding: EdgeInsets.only(top: 10, left: 10, right: 10), child:
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(padding: EdgeInsets.all(2),
            child: ElevatedButton(
              child: Padding(padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 40.0,
                        ),
                            SizedBox(width: 10),
                            Text('Exit', textAlign: TextAlign.center),
                ]),),
                onPressed: () => this.onExitPressed(),
                style: ElevatedButton.styleFrom(
                primary: Colors.redAccent.shade700, // background
                onPrimary: Colors.white, // foreground
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(padding: EdgeInsets.all(2),
            child: ElevatedButton(
              child: Padding(padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Restart', textAlign: TextAlign.center),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 40.0,
                      ),


                    ]),),
              onPressed: () => this.onRestartPressed(),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[900], // background
                onPrimary: Colors.white, // foreground
              ),
            ),
          ),
        ),

    ],
    ),);
  }

  void onRestartPressed(){

  }

  void onExitPressed(){
    saveState();
  }

  void onSavePressed(){

  }


}



class Game2048CustomPainter extends CustomPainter{
  _Game2048State _currentState;
  double _paddingTile = 3;


  Game2048CustomPainter(this._currentState);

  @override
  void paint(Canvas canvas, Size size) {

    Paint pB = Paint();
    pB..color = Colors.black;
    //print('${size.width} ${size.height}');
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), pB);
    //calculate sizes
    
    double tileWidth = size.width / _currentState.rowSize;
    //draw grid
    if(_currentState._currentState == Animation2048State.MOVING){
      //draw grid seperately
      for(int i = 0; i < _currentState.columnSize; i++) {
        for (int l = 0; l < _currentState.rowSize; l++) {
          canvas.drawRect(Rect.fromLTWH(toX(i, tileWidth), toY(l, tileWidth), tileWidth - 2 * _paddingTile, tileWidth - 2* _paddingTile), valueToColor(0));
        }
      }
    }



    //update area
    for(int i = 0; i < _currentState.columnSize; i++){
      for(int l = 0; l < _currentState.rowSize; l++){
        //print('$i $l: ${toX(i, tileWidth)}, ${toY(l, tileWidth)}; $tileWidth}');
        if(_currentState._currentState == Animation2048State.MOVING){

          //draw all values in motion
          int curInd = _currentState.toIndex(i, l);
          double xTemp = toXMoving(curInd, _currentState.targetID[curInd], 0, _currentState.animationMoving.value, tileWidth) + _paddingTile;
          double yTemp = toYMoving(curInd, _currentState.targetID[curInd], 0, _currentState.animationMoving.value, tileWidth) + _paddingTile;
          if(_currentState.values[curInd] != 0){
            canvas.drawRect(Rect.fromLTWH(xTemp, yTemp, tileWidth - 2 * _paddingTile, tileWidth - 2* _paddingTile), valueToColor(_currentState.values[curInd]));
          }
        }else if(_currentState._currentState == Animation2048State.APPEARING){
          canvas.drawRect(Rect.fromLTWH(toX(i, tileWidth), toY(l, tileWidth), tileWidth - 2 * _paddingTile, tileWidth - 2* _paddingTile), valueToColor(_currentState.values[_currentState.toIndex(i, l)]));
        }else{
          //draw value with color
          canvas.drawRect(Rect.fromLTWH(toX(i, tileWidth), toY(l, tileWidth), tileWidth - 2 * _paddingTile, tileWidth - 2* _paddingTile), valueToColor(_currentState.values[_currentState.toIndex(i, l)]));
        }


        //int curInd = _currentState.toIndex(i, l);
        //tp[curInd].paint(canvas, Offset((i+0.5) * tileWidth - tp[curInd].width/2, (l+0.5) * tileWidth - tp[curInd].height/2));
      }
    }
    updateTextPainterText(size, canvas, tileWidth);
  }

  void updateTextPainterText(Size size, Canvas canvas, double tileWidth){
    List<TextPainter> _tp = List.filled(16, null);


    for(int i = 0; i < _currentState.columnSize; i++) {
      for (int l = 0; l < _currentState.rowSize; l++) {
        int curInd = _currentState.toIndex(i, l);
        int val = _currentState.values[curInd];
        if(val == 0){
          continue;
        }
        String text = val == 0 ? '': val.toString();
        double _fontSize = 24;
        if(_currentState._currentState == Animation2048State.APPEARING && _currentState.isAppearing[curInd]){
          _fontSize = 24 * _currentState.animationAppearing.value;
        }
          TextSpan span = TextSpan(text: '$text',
              style: new TextStyle(color: Colors.black, fontSize: _fontSize));
          _tp[curInd] = TextPainter(text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,);
          _tp[curInd].layout(minWidth: 0, maxWidth: size.width);
        if(_currentState._currentState != Animation2048State.MOVING){
          _tp[curInd].paint(canvas, Offset((i + 0.5) * tileWidth - _tp[curInd].width / 2,
              (l + 0.5) * tileWidth - _tp[curInd].height / 2));
        }else{
          //moving state, move number
          double xTemp = toXMoving(curInd, _currentState.targetID[curInd], 0.5, _currentState.animationMoving.value, tileWidth);
          double yTemp = toYMoving(curInd, _currentState.targetID[curInd], 0.5, _currentState.animationMoving.value, tileWidth);
          _tp[curInd].paint(canvas, Offset(xTemp - _tp[curInd].width / 2,
              yTemp - _tp[curInd].height / 2));
        }

      }
    }
  }

  Paint valueToColor(int value){
    Color c;
    switch(value) {
      case 0:
        c = Color.fromARGB(255, 240, 240, 240);
        break;
      case 2:
        c = Color.fromARGB(255, 238, 228, 218);
        break;
      case 4:
        c = Color.fromARGB(255, 237, 224, 200);
        break;
      case 8:
        c = Color.fromARGB(255, 242, 177, 121);
        break;
      case 16:
        c = Color.fromARGB(255, 245, 149, 99);
        break;
      case 32:
        c = Color.fromARGB(255, 246, 124, 95);
        break;
      case 64:
        c = Color.fromARGB(255, 246, 94, 59);
        break;
      case 128:
        c = Color.fromARGB(255, 237, 207, 114);
        break;
      case 256:
        c = Color.fromARGB(255, 237, 204, 94);
        break;
      case 512:
        c = Color.fromARGB(255, 243, 215, 116);
        break;
      case 1024:
        c = Color.fromARGB(255, 243, 215, 116);
        break;
      case 2048:
        c = Color.fromARGB(255, 243, 215, 116);
        break;
      default:
        c = Color.fromARGB(255, 237, 224, 200);
    }
    Paint p = Paint();
    p..color = c;
    return p;
  }

  double toXMoving(int indexSource, int indexTarget, double offset, double progress, double tileWidth){
    double xSource = (_currentState.toIndexX(indexSource) + offset) * tileWidth;
    double xTarget = (_currentState.toIndexX(indexTarget) + offset) * tileWidth;
    double diff = xTarget - xSource;
    return xSource + diff * progress;
  }
  double toYMoving(int indexSource, int indexTarget, double offset, double progress, double tileWidth){
    double ySource = (_currentState.toIndexY(indexSource) + offset) * tileWidth;
    double yTarget = (_currentState.toIndexY(indexTarget) + offset) * tileWidth;
    double diff = yTarget - ySource;
    return ySource + diff * progress;
  }


  double toX(int indexX, double tileWidth){
    return (indexX * tileWidth).toDouble() + _paddingTile;
  }
  double toY(int indexY, double tileWidth){
    return (indexY * tileWidth).toDouble() + _paddingTile;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return _currentState._isInAnimation;
  }

}


