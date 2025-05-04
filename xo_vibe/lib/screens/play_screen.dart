import 'dart:math';

import 'package:flutter/material.dart';
import 'package:xo_vibe/components/custom_button.dart';
import 'package:xo_vibe/screens/home_screen.dart';

class PlayScreen extends StatefulWidget {
  static final String routeName = "/play_screen";

  final bool? isVsComputer;
  final String? difficulty;
  const PlayScreen({super.key, this.isVsComputer, this.difficulty});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  String? currentPlayer;

  List<String>? board;

  int scoreX = 0, scoreO = 0;

  int? tapNumber;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    setState(() {
      currentPlayer = "X";
      board = ["", "", "", "", "", "", "", "", ""];
      tapNumber = 0;
    });
  }

  handleTap(int index) {
    if (board?[index] == "") {
      if (widget.isVsComputer!) {
        setState(() {
          board?[index] = currentPlayer!;
          tapNumber = tapNumber! + 1;
          if (checkWin() != "") {
            return;
          } else if (tapNumber! >= 9) {
            showResult("Draw");
            tapNumber = 0;
            return;
          } else {
            currentPlayer = 'O';
            _computerMove();
          }
        });
      } else {
        setState(() {
          board?[index] = currentPlayer!;
          currentPlayer == "X" ? currentPlayer = "O" : currentPlayer = "X";
          tapNumber = tapNumber! + 1;
          if (checkWin() != "") {
            return;
          } else if (tapNumber! >= 9) {
            showResult("Draw");
            tapNumber = 0;
            return;
          }
        });
      }
    }
  }

  void _computerMove() {
    Future.delayed(Duration(milliseconds: 500), () {
      int move;

      if (widget.difficulty == "Easy") {
        move = _getRandomMove();
      } else {
        move = _getBestMove();
      }

      setState(() {
        board?[move] = 'O';
        tapNumber = tapNumber! + 1;
        if (checkWin() != "") {
          return;
        } else if (tapNumber! >= 9) {
          showResult("Draw");
          tapNumber = 0;
          return;
        }
        currentPlayer = 'X';
      });
    });
  }

  String? checkWin() {
    if ((board?[0] != "") &&
        (board?[0] == board?[1]) &&
        (board?[0] == board?[2])) {
      showResult(board![0]);
      return board?[0];
    } else if ((board?[3] != "") &&
        (board?[3] == board?[4]) &&
        (board?[3] == board?[5])) {
      showResult(board![3]);
      return board?[3];
    } else if ((board?[6] != "") &&
        (board?[6] == board?[7]) &&
        (board?[6] == board?[8])) {
      showResult(board![6]);
      return board?[6];
    } else if ((board?[0] != "") &&
        (board?[0] == board?[3]) &&
        (board?[0] == board?[6])) {
      showResult(board![0]);
      return board?[0];
    } else if ((board?[1] != "") &&
        (board?[1] == board?[4]) &&
        (board?[1] == board?[7])) {
      showResult(board![1]);
      return board?[1];
    } else if ((board?[2] != "") &&
        (board?[2] == board?[5]) &&
        (board?[2] == board?[8])) {
      showResult(board![2]);
      return board?[2];
    } else if ((board?[0] != "") &&
        (board?[0] == board?[4]) &&
        (board?[0] == board?[8])) {
      showResult(board![0]);
      return board?[0];
    } else if ((board?[2] != "") &&
        (board?[2] == board?[4]) &&
        (board?[2] == board?[6])) {
      showResult(board![2]);
      return board?[2];
    }
    return "";
  }

  int _getRandomMove() {
    List<int> empty = [];
    for (int i = 0; i < 9; i++) {
      if (board?[i] == '') empty.add(i);
    }
    return empty[Random().nextInt(empty.length)];
  }

  int _getBestMove() {
    int bestScore = -1000;
    int move = -1;

    for (int i = 0; i < 9; i++) {
      if (board![i] == '') {
        board![i] = 'O';
        int score = _minimax(board!, 0, false);
        board![i] = '';
        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }
    return move;
  }

  int _minimax(List<String> newBoard, int depth, bool isMaximizing) {
    String result = _evaluateBoard(newBoard);
    if (result == "O") return 10 - depth;
    if (result == "X") return depth - 10;
    if (!newBoard.contains('')) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (newBoard[i] == "") {
          newBoard[i] = "O";
          int score = _minimax(newBoard, depth + 1, false);
          newBoard[i] = "";
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (newBoard[i] == "") {
          newBoard[i] = "X";
          int score = _minimax(newBoard, depth + 1, true);
          newBoard[i] = "";
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  String _evaluateBoard(List<String> board) {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      String a = board[condition[0]];
      String b = board[condition[1]];
      String c = board[condition[2]];

      if (a != "" && a == b && b == c) {
        return a;
      }
    }

    return "";
  }

  void showResult(String message) {
    setState(() {
      if (message == "Draw") {
        scoreX += 1;
        scoreO += 1;
      } else if (message == "X") {
        scoreX += 3;
      } else if (message == "O") {
        scoreO += 3;
      }
    });

    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        icon: Image.asset(
          message == "Draw" ? "images/draw.png" : "images/win.png",
          height: MediaQuery.of(context).size.height / 5,
        ),
        title: Center(
            child: Text(message == "Draw" ? "Draw" : "Player $message win")),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                },
                child: const Text(
                  'Exit',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  initGame();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Play again',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff424242),
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Player X \n$scoreX",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Player O \n$scoreO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTap: () {
                      handleTap(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${board?[index]}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            customButton(context, textButton: "Reset game", function: initGame),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
