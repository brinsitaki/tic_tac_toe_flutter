import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xo_vibe/screens/home_screen.dart';

class PlayOnlineScreen extends StatefulWidget {
  static final String routeName = "/play_online_screen";

  const PlayOnlineScreen({super.key});

  @override
  State<PlayOnlineScreen> createState() => _PlayOnlineScreenState();
}

class _PlayOnlineScreenState extends State<PlayOnlineScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String? opponentUserId;
  String? gameId;
  Timer? timeoutTimer;

  int scoreX = 0;
  int scoreO = 0;
  int? tapNumber;

  @override
  void initState() {
    super.initState();
    joinQueue();
  }

  void joinQueue() async {
    final queue = await FirebaseFirestore.instance.collection("queue").get();

    bool matched = false;

    for (var user in queue.docs) {
      if (user.id != currentUserId) {
        opponentUserId = user.id;
        await FirebaseFirestore.instance
            .collection("queue")
            .doc(opponentUserId)
            .delete();

        final gameDoc =
            await FirebaseFirestore.instance.collection("games").add({
          "players": [currentUserId, opponentUserId],
          "board": List.filled(9, ''),
          "turn": currentUserId,
          "scoreCurrentUser": scoreX,
          "scoreOpponentUser": scoreO,
        });

        setState(() {
          gameId = gameDoc.id;
        });

        matched = true;
        return;
      }
    }

    if (!matched) {
      await FirebaseFirestore.instance
          .collection("queue")
          .doc(currentUserId)
          .set({"timestamp": FieldValue.serverTimestamp()});

      timeoutTimer = Timer(Duration(minutes: 1), () async {
        await FirebaseFirestore.instance
            .collection("queue")
            .doc(currentUserId)
            .delete();
        if (mounted) Navigator.pop(context);
      });

      FirebaseFirestore.instance
          .collection("games")
          .where("players", arrayContains: currentUserId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          timeoutTimer?.cancel();
          setState(() {
            gameId = snapshot.docs.first.id;
            opponentUserId = snapshot.docs.first
                .data()["players"]
                .firstWhere((p) => p != currentUserId);
          });
        }
      });
    }
  }

  void initGame() async {
    final gameDoc =
        await FirebaseFirestore.instance.collection("games").doc(gameId).get();

    if (gameDoc.exists) {
      final data = gameDoc.data()!;
      scoreX = data["scoreCurrentUser"] ?? 0;
      scoreO = data["scoreOpponentUser"] ?? 0;
    }

    await FirebaseFirestore.instance.collection("games").doc(gameId).set({
      "players": [currentUserId, opponentUserId],
      "board": List.filled(9, ''),
      "turn": currentUserId,
      "scoreCurrentUser": scoreX,
      "scoreOpponentUser": scoreO,
    });

    setState(() {
      tapNumber = 0;
    });
  }

  void showResult(String message) async {
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
            child: Text(message == "Draw" ? "Draw" : "Player $message wins")),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  initGame();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Play again",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> handleTap(DocumentSnapshot gameDoc, int index) async {
    final data = gameDoc.data() as Map<String, dynamic>;

    if ((data["board"][index] != "") || (data["turn"] != currentUserId)) return;

    final board = List<String>.from(data["board"]);
    final players = List<String>.from(data["players"]);

    final symbol = currentUserId == players[0] ? "X" : "O";
    board[index] = symbol;

    final winner = checkWin(board);
    final isDraw = !board.contains("");

    final nextTurn = players.firstWhere((p) => p != currentUserId);

    await gameDoc.reference.update({
      "board": board,
      "turn": winner == null && !isDraw ? nextTurn : null,
      "scoreCurrentUser": scoreX,
      "scoreOpponentUser": scoreO,
    });

    if (winner != null) {
      showResult(winner);
    } else if (isDraw) {
      showResult("Draw");
    }
  }

  String? checkWin(List<String> board) {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      final a = board[pattern[0]];
      final b = board[pattern[1]];
      final c = board[pattern[2]];
      if (a != '' && a == b && b == c) {
        return a;
      }
    }

    return null;
  }

  @override
  void dispose() {
    timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (gameId == null) {
      return Scaffold(
        backgroundColor: Color(0xff424242),
        body: SafeArea(
          child: Column(
            children: [
              Spacer(),
              Center(
                child: Image.asset(
                  "images/global-network.png",
                  width: MediaQuery.of(context).size.width / 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Waiting for opponent ...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CircularProgressIndicator(color: Colors.deepOrange),
              Spacer(),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("games")
          .doc(gameId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        final board = List<String>.from(snapshot.data!.get("board"));

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
                      "Player X\n$scoreX",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Player O\n$scoreO",
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
                          handleTap(snapshot.data!, index);
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
                              board[index],
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
              ],
            ),
          ),
        );
      },
    );
  }
}
