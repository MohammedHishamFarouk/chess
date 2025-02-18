import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/helper/functions.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              return Square(
                isWhite: isWhite(index),
                piece: ChessPiece(
                  type: ChessPieceType.pawn,
                  isWhite: false,
                  imagePath: 'assets/pawn.svg',
                ),
              );
            },
            itemCount: 64,
          ),
        ),
      ),
    );
  }
}
