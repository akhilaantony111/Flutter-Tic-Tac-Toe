import "dart:io";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayer/audioplayer.dart';
import "dart:math";
import 'package:path_provider/path_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import "dart:async";

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class SoundManager {
  Future play(localFileName, audioPlayer) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = new File("${dir.path}/$localFileName");
    if (!(await file.exists())) {
      final soundData = await rootBundle.load("assets/$localFileName");
      final bytes = soundData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }
    await audioPlayer.play(file.path, isLocal: true);
    
    audioPlayer.onPlayerStateChanged.listen((s) {
     if (s == AudioPlayerState.COMPLETED) {
        audioPlayer.play(file.path, isLocal: true);
      }
    });
  }
}

    // if(AudioPlayerState.COMPLETED == true){
    // }

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  var firstUser = 'X';
  var secondUser = 'O';
  var currentUser = 'X';
  var moves = 0;
  var winner;
  bool gameOver = false;
  bool musicOn = true;
  var iconSize = 50;
  List board = ["", "", "", "", "", "", "", "", ""];
  List board_new = [ 
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
  var themeColor = Colors.indigo;
  AudioPlayer audioPlayer = new AudioPlayer();
  SoundManager soundManager = new SoundManager();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
       case AppLifecycleState.inactive:
       audioPlayer.stop();
       break;
      case AppLifecycleState.paused: 
       break;
      case AppLifecycleState.suspending:
       break;
      case AppLifecycleState.resumed:
        if (musicOn) {
          soundManager.play("song.mp3", audioPlayer);
        }
        break;
    }
  }
  
  
  Widget build(BuildContext context) {
    final title = 'Tic Tac Toe';
  
    if (musicOn) {
      soundManager.play("song.mp3", audioPlayer);
    }
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
                if (musicOn) {
                  soundManager.play("song.mp3", audioPlayer);
                } else {
                  audioPlayer.stop();
                }
              },
            ),
          )
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
                     child: Text(board_new[index]["name"],
                         style: TextStyle(
                           color: board_new[index]["color"],
                           fontWeight: FontWeight.bold,
                           fontSize: board_new[index]["size"],
                         )),
                    // child: (board[index] == 'X') ?
                    // FlareActor("assets/TicTac.flr", animation:"tictoc")
                    //     : (board[index] == 'O') ? FlareActor("assets/icon2.flr", alignment:Alignment.center, fit:BoxFit.contain, animation:"img3") : null,
                    ),
                  ),
                  onTap: () {
                    if (board_new[index]["name"] == "" && winner == null) {
                      onCellClick(index, context);
                    }
                  },
                );
              })),
        ),
      ),
    );
  }

  onCellClick(index, context) {
    if (board_new[index]["name"] == "" && gameOver == false) {
//      SystemSound.play(SystemSoundType.click);
//      soundManager.play("rename.wav", audioPlayer);
      setState(() {
        board_new[index]["name"] = currentUser;
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
    winningCombo.forEach((combo) {
      if ((board_new[combo[0]]["name"] != "") &&
          (board_new[combo[1]]["name"] != "") &&
          (board_new[combo[2]]["name"] != "") &&
          (board_new[combo[0]]["name"] == board_new[combo[1]]["name"]) &&
          (board_new[combo[1]]["name"] == (board_new[combo[2]]["name"]))) {
            var tempBoard = board_new;
            board_new[combo[0]]["color"] = Colors.black;
            board_new[combo[0]]["size"] = 75.0;
            board_new[combo[1]]["color"] = Colors.black;
            board_new[combo[1]]["size"] = 75.0;
            board_new[combo[2]]["color"] = Colors.black;
            board_new[combo[2]]["size"] = 75.0;
            setState(() {
              winner = currentUser;
              gameOver = true;
              board_new = tempBoard;
              currentUser = (currentUser == firstUser) ? secondUser : firstUser;
            });
            var _timer = new Timer(Duration(milliseconds: 500), () {
                showMyDialog(context, 'Winner is Player $currentUser !!');
            });
      }
    });
    if (gameOver == false && moves == 9) {
      setState(() {
        gameOver = true;
      });
      showMyDialog(context, 'It is a draw match !!');
    }
  }

  void showMyDialog(context, message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Game Over",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            content: Text(
              message,
              style: TextStyle(
                  color: themeColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  textBaseline: TextBaseline.alphabetic),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                  reset();
                },
              ),
            ],
          );
        });
  }

  reset() {
    setState(() {
      firstUser = 'X';
      secondUser = 'O';
      currentUser = 'X';
      moves = 0;
      winner = null;
      gameOver = false;
      board = ["", "", "", "", "", "", "", "", ""];
      board_new = [ 
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

  randomColors() {
    var list = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.amber,
      Colors.cyan,
      Colors.brown
    ];

// generates a new Random object
    final _random = new Random();

// generate a random index based on the list length
// and use it to retrieve the element
    var element = list[_random.nextInt(list.length)];
    return element;
  }
}
