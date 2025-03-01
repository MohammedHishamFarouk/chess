import 'package:chess/components/dead_piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/helper/functions.dart';
import 'package:chess/providers/board_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardProvider>(
      builder: (context, boardProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade700,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 700),
                child: Column(
                  children: [
                    //taken white pieces
                    Container(
                      height:
                          boardProvider.whitePiecesTaken.isNotEmpty ? 50 : 0,
                      color: Colors.black12,
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: boardProvider.whitePiecesTaken.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                        ),
                        itemBuilder: (context, index) => DeadPiece(
                          imagePath:
                              boardProvider.whitePiecesTaken[index].imagePath,
                          isWhite: true,
                        ),
                      ),
                    ),
                    //game Status
                    Visibility(
                      visible: boardProvider.checkStatus,
                      child: Text("CHECK!!"),
                    ),
                    Expanded(
                      flex: 3,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                        ),
                        itemBuilder: (context, index) {
                          int row = index ~/ 8;
                          int col = index % 8;

                          //check if square is selected
                          bool isSelected = boardProvider.selectedRow == row &&
                              boardProvider.selectedCol == col;

                          //check if this square is a valid moves
                          bool isValidMove = false;
                          for (var position in boardProvider.validMoves) {
                            //compare row and col
                            if (position[0] == row && position[1] == col) {
                              isValidMove = true;
                            }
                          }
                          return Square(
                            isWhite: isWhite(index),
                            piece: boardProvider.board[row][col],
                            isSelected: isSelected,
                            onTap: () =>
                                boardProvider.pieceSelected(row, col, context),
                            isValidMoves: isValidMove,
                          );
                        },
                        itemCount: 64,
                      ),
                    ),
                    //taken black pieces
                    Container(
                      height:
                          boardProvider.blackPiecesTaken.isNotEmpty ? 50 : 0,
                      color: Colors.black12,
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: boardProvider.blackPiecesTaken.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                        ),
                        itemBuilder: (context, index) => DeadPiece(
                          imagePath:
                              boardProvider.blackPiecesTaken[index].imagePath,
                          isWhite: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
