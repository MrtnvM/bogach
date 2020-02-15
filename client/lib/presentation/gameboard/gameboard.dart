import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GameBoard')),
    );
  }
}
