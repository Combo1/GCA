
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

//TODO add score
class _Game2048State extends State<Game2048Screen> with TickerProviderStateMixin{

  final int rowSize;
  final int columnSize;
  int totalSize;
  bool isGameRunning = true;

  List<int> values;
  List<int> valuesAfter;
  List<bool> isAppearing;
  List<int> targetID;

  bool _isInAnimation = false;
  bool _requireTextUpdate = false;

  //for swiping
  bool _isHorizontal = false;
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  String _resultSwipe = '';
  Random _random = Random();
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


  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight,]);//force potrait mode in this mode
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
    _isInAnimation = true;
    //print('start appearing');
    setState(() {

      _currentState = Animation2048State.APPEARING;
    });

  }

  void stopTimerAppearing(){
    _isInAnimation = false;
    //print('Stop appearing');
    setState(() {
      _currentState = Animation2048State.FIXED_POSITION;
    });
  }

  void startTimerMoving(){
    //print('start moving');
    controllerMoving.reset();
    controllerMoving.forward();
    _isInAnimation = true;
    setState(() {

      _currentState = Animation2048State.MOVING;
    });
  }

  void stopTimerMoving(){
    //print('Stop Moving');
    setState(() {
      values = valuesAfter;
    });

    startTimerAppearing();
    _isInAnimation = false;

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
    Tuple3 nextState = getNextState(x, values);
    //check if moved, dont apply next state if state didn't change
    if(isSameState(values, nextState.item1)){
      print('no change occured, IsGameActive: $isGameRunning');
      return;
    }else{
      print('change has occured');
      //continue and apply event changes
      print('Target: ${nextState.item2}');
      targetID = nextState.item2;
      //add new random tile to state
      Tuple2 stateAfterPlacement = placeRandomTile(nextState.item1);
      valuesAfter = stateAfterPlacement.item1;
      isAppearing = stateAfterPlacement.item2;
      for(int i = 0; i < isAppearing.length; i++){
        isAppearing[i] = isAppearing[i] || nextState.item3[i];
      }
      //check possible game over state
      if(isGameOver(valuesAfter)){
        print('Game Over discovered');
        isGameRunning = false;
      }
      startTimerMoving();

    }
  }


  //applies swipe on current state and returns changes
  Tuple3 getNextState(_Direction x, List<int> currentState){
    List<int> stateAfter = List.filled(totalSize, 0);
    List<int> targetID = List.filled(totalSize, 0);
    List<bool> hasMerged = List.filled(totalSize, false);
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
    return Tuple3(stateAfter, targetID, hasMerged);
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
        moveTilesEvent(_Direction.RIGHT);
      });
    }else if(_offsetX < 0){
      setState(() {
        _resultSwipe = 'left';
        moveTilesEvent(_Direction.LEFT);
      });
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
      Scaffold(
        body: SafeArea(child:
        GestureDetector(
          onHorizontalDragEnd: (e) => this.onHorizontalDragEnd(e),
          onVerticalDragEnd: (e) => this.onVerticalDragEnd(e),
          onHorizontalDragUpdate: (e) => this.onDragUpdate('Horizontal', e),
          onVerticalDragUpdate: (e) => this.onDragUpdate('Vertical: ', e),
          onHorizontalDragStart: (e) => this.onHorizontalDragStart(e),
          onVerticalDragStart: (e) => this.onVerticalDragStart(e),
          child: Column(children: [
          Padding(
            padding: EdgeInsets.only(bottom: 50, top: 50),
            child: Text('Score: 0, $_resultSwipe,', style: TextStyle(fontSize: 40)),
          ),
            Text('$_currentState,', style: TextStyle(fontSize: 20)),
          FittedBox(alignment: Alignment.center, fit: BoxFit.fitWidth, child:
            SizedBox.fromSize(
                size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                child: CustomPaint(painter: Game2048CustomPainter(this)
                ),
            ),
          ),
        ],
        ),
      ),
      ),
    );
  }



}



class Game2048CustomPainter extends CustomPainter{
  _Game2048State _currentState;
  double _paddingTile = 5;

  //TODO animate states APPEARING and MOVING
  Game2048CustomPainter(this._currentState){

  }

  @override
  void paint(Canvas canvas, Size size) {

    Paint pB = Paint();
    pB..color = Colors.black;
    //print('${size.width} ${size.height}');
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), pB);
    //calculate sizes
    Paint pW = Paint();
    pW..color = Colors.white;
    double tileWidth = size.width / _currentState.rowSize;
    //update text content



    //update area
    for(int i = 0; i < _currentState.columnSize; i++){
      for(int l = 0; l < _currentState.rowSize; l++){
        //print('$i $l: ${toX(i, tileWidth)}, ${toY(l, tileWidth)}; $tileWidth}');
        canvas.drawRect(Rect.fromLTWH(toX(i, tileWidth), toY(l, tileWidth), tileWidth - 2 * _paddingTile, tileWidth - 2* _paddingTile), pW);

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
          double xTemp = toXMoving(curInd, _currentState.targetID[curInd], _currentState.animationMoving.value, tileWidth);
          double yTemp = toYMoving(curInd, _currentState.targetID[curInd], _currentState.animationMoving.value, tileWidth);
          _tp[curInd].paint(canvas, Offset(xTemp - _tp[curInd].width / 2,
              yTemp - _tp[curInd].height / 2));
        }

      }
    }
  }

  double toXMoving(int indexSource, int indexTarget, double progress, double tileWidth){
    double xSource = (_currentState.toIndexX(indexSource) + 0.5) * tileWidth;
    double xTarget = (_currentState.toIndexX(indexTarget) + 0.5) * tileWidth;
    double diff = xTarget - xSource;
    return xSource + diff * progress;
  }
  double toYMoving(int indexSource, int indexTarget, double progress, double tileWidth){
    double ySource = (_currentState.toIndexY(indexSource) + 0.5) * tileWidth;
    double yTarget = (_currentState.toIndexY(indexTarget) + 0.5) * tileWidth;
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
    // TODO: implement shouldRepaint
    return _currentState._isInAnimation;
  }

}