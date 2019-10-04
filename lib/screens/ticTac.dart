//Many operations related to input and output are asynchronous and are handled using Futures or Streams, both of which are defined in the dart:async library.
import "dart:async";
//Audio Player
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/components/alert.dart';
import 'package:tic_tac_toe/components/randomColors.dart';
import 'package:tic_tac_toe/components/singleTouchRecognizerWidget.dart';
import 'package:tic_tac_toe/components/soundManager.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  var firstUser = 'X';
  var secondUser = 'O';
  var currentUser = 'X';
  var moves = 0;
  var winner;
  bool gameOver = false;
  bool musicOn = true;
  var board = [
    {'name': '', 'color': Colors.white, 'size': 50.0},
    {'name': '', 'color': Colors.white, 'size': 50.0},
    {'name': '', 'color': Colors.white, 'size': 50.0},
    {'name': '', 'color': Colors.white, 'size': 50.0},
    {'name': '', 'color': Colors.white, 'size': 50.0},
    {'name': '', 'color': Colors.white, 'size': 50.0},
    {'name': '', 'color': Colors.white, 'size': 50.0},
    {'name': '', 'color': Colors.white, 'size': 50.0},
    {'name': '', 'color': Colors.white, 'size': 50.0}
  ];
  var themeColor = randomColors();
  AudioPlayer audioPlayer = new AudioPlayer();
  SoundManager soundManager = new SoundManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //App life cycle management, if any actions to be performed when the app is inactive, paused, suspended or resumed.
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.suspending:
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  Widget build(BuildContext context) {
    final title = 'Tic Tac Toe';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: themeColor,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              child: Icon(musicOn ? Icons.volume_up : Icons.volume_off),
              onTap: () {
                setState(() {
                  musicOn = !musicOn;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: themeColor,
          onPressed: () {
            reset();
          },
          child: Icon(Icons.refresh)),
      body: Center(
        child: Container(
          width: 340,
          height: 340,
          child: SingleTouchRecognizerWidget(
              child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  children: List.generate(9, (index) {
                    return InkWell(
                      child: Container(
                        width: 110,
                        height: 110,
                        color: themeColor,
                        margin: EdgeInsets.all(3),
                        child: Center(
                          child: Text(board[index]["name"],
                              style: TextStyle(
                                color: board[index]["color"],
                                fontWeight: FontWeight.bold,
                                fontSize: board[index]["size"],
                              )),
                        ),
                      ),
                      onTap: () {
                        if (board[index]["name"] == "" && winner == null) {
                          onCellClick(index, context);
                        }
                      },
                    );
                  }))),
        ),
      ),
    );
  }

  onCellClick(index, context) {
    if (gameOver == false) {
      if (musicOn) {
        soundManager.play('button.mp3', audioPlayer);
      }
      setState(() {
        board[index]["name"] = currentUser;
        moves = moves + 1;
        winner = checkWinner(moves, context);
        currentUser = (currentUser == firstUser) ? secondUser : firstUser;
      });
    }
  }

  checkWinner(moves, context) {
    var winningCombo = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 4, 8],
      [2, 4, 6],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8]
    ];
    for (final combo in winningCombo) {
      if ((board[combo[0]]["name"] != "") &&
          (board[combo[1]]["name"] != "") &&
          (board[combo[2]]["name"] != "") &&
          (board[combo[0]]["name"] == board[combo[1]]["name"]) &&
          (board[combo[1]]["name"] == (board[combo[2]]["name"]))) {
        var tempBoard = board;
        tempBoard[combo[0]]["color"] = tempBoard[combo[1]]["color"] =
            tempBoard[combo[2]]["color"] = Colors.black;
        tempBoard[combo[0]]["size"] =
            tempBoard[combo[1]]["size"] = tempBoard[combo[2]]["size"] = 75.0;
        setState(() {
          winner = currentUser;
          gameOver = true;
          board = tempBoard;
          currentUser = (currentUser == firstUser) ? secondUser : firstUser;
        });
        showMyDialog(
            context, 'Winner is Player $winner !!', themeColor, reset());
        break;
      } else {
        if (gameOver == false && moves == 9) {
          setState(() {
            gameOver = true;
          });
          showMyDialog(context, 'It is a draw match !!', themeColor, reset());
          break;
        }
      }
    }
  }

  reset() {
    setState(() {
      firstUser = 'X';
      secondUser = 'O';
      currentUser = 'X';
      moves = 0;
      winner = null;
      gameOver = false;
      board = [
        {'name': '', 'color': Colors.white, 'size': 50.0},
        {'name': '', 'color': Colors.white, 'size': 50.0},
        {'name': '', 'color': Colors.white, 'size': 50.0},
        {'name': '', 'color': Colors.white, 'size': 50.0},
        {'name': '', 'color': Colors.white, 'size': 50.0},
        {'name': '', 'color': Colors.white, 'size': 50.0},
        {'name': '', 'color': Colors.white, 'size': 50.0},
        {'name': '', 'color': Colors.white, 'size': 50.0},
        {'name': '', 'color': Colors.white, 'size': 50.0}
      ];
      themeColor = randomColors();
    });
  }
}
