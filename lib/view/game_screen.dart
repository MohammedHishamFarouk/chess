import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width > 729
        ? 729 - 62
        : MediaQuery.sizeOf(context).width - 62;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Wrap(
              children: createBoard(screenWidth),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createBoard(double screenWidth) {
    final board = <Widget>[];
    final columnLetters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    bool rowFinished = false;

    for (int i = 0; i < 72; i++) {
      if (i % 8 == 0) {
        rowFinished = !rowFinished;
        board.add(
          SizedBox(
            width: 30,
            height: i < 8 ? 30 : screenWidth / 8,
            child: Center(
              child: Text(
                i == 0 ? '' : '${i / 8}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }

      final square = Container(
        width: screenWidth / 8,
        height: i < 8 ? 30 : screenWidth / 8,
        color: i < 8 ? Colors.transparent : getSquareColor(rowFinished, i),
        child: i < 8
            ? Center(
                child: Text(
                  columnLetters[i],
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : null,
      );
      board.add(square);
    }
    return board;
  }

  Color getSquareColor(bool rowFinished, int i) {
    if (rowFinished) {
      return i.isEven ? Colors.grey : Colors.grey.shade900;
    } else {
      return i.isEven ? Colors.grey.shade900 : Colors.grey;
    }
  }
}
