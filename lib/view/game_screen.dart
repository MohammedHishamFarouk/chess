import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final columnLetters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    bool rowFinished = false;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemBuilder: (context, index) {
              if (index % 8 == 0 && index != 0) {
                rowFinished = !rowFinished;
              }
              return Container(
                color: getSquareColor(rowFinished, index),
              );
            },
            itemCount: 64,
          ),
        ),
      ),
    );
  }

  Color getSquareColor(bool rowFinished, int i) {
    if (rowFinished) {
      return i.isEven ? Colors.grey : Colors.grey.shade900;
    } else {
      return i.isEven ? Colors.grey.shade900 : Colors.grey;
    }
  }
}
