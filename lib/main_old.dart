import 'package:flutter/material.dart';
import "dart:math";

void main() => runApp(MaterialApp(
  home: MyApp(),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
//            reset();
          },
          child: Icon(Icons.refresh)),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: Cell(index: 0),
        )
      ),
    );
  }
}

class Cell extends StatefulWidget {
  final index;

  Cell({Key key, @required this.index}) : super(key: key);
  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  var firstUser = 'X';
  var secondUser = 'O';
  var currentUser = 'X';
  var moves = 0;
  var winner = null;
  bool gameOver = false;
  List board = ["", "", "", "", "", "", "", "", ""];
  var themeColor = Colors.indigo;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        children: List.generate(9, (index) {
          return InkWell(
            child: Container(
              width: 100,
              height: 100,
              color: themeColor,
              margin: EdgeInsets.all(3),
              child: Center(
                child: Text(board[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    )),
              ),
            ),
            onTap: () {
              if (board[index] == "" && winner == null) {
                onCellClick(index, context);
              }
            },
          );
        }));

  }


  onCellClick(index, context) {
    if (board[index] == "" && gameOver == false) {
      setState(() {
        board[index] = currentUser;
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
    return winningCombo.forEach((combo) {
      if ((board[combo[0]] != "") &&
          (board[combo[1]] != "") &&
          (board[combo[2]] != "") &&
          (board[combo[0]] == board[combo[1]]) &&
          (board[combo[1]] == (board[combo[2]]))) {
        print("Winner is $currentUser");
        setState(() {
          winner = currentUser;
          gameOver = true;
        });
        showMyDialog(context, 'Winner is $currentUser !!');
      }
      if (gameOver == false && moves == 9) {
        showMyDialog(context, 'It is a draw match !!');
        setState(() {
          gameOver = true;
        });
      }
    });
  }

  void showMyDialog(context, message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Game Over",
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
                message,
                style: TextStyle(color: themeColor)
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK', style: TextStyle(color: themeColor)),
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
