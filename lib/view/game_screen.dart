import 'dart:developer';

import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/helper/functions.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<ChessPiece?>> board;

  //the currently selected piece
  //if no piece is selected this will be null
  ChessPiece? selectedPiece;
  //the row index of the selected piece
  //the default value will be -1 if no piece is selected
  int selectedRow = -1;
  //the col index of the selected piece
  //the default value will be -1 if no piece is selected
  int selectedCol = -1;
  //a list of valid moves for our selected piece
  //each move is represented as a list of 2 elements: row,column
  List<List<int>> validMoves = [];
  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));
    //place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: 'assets/pawn.svg',
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'assets/pawn.svg',
      );
    }
    //place rooks
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'assets/rook.svg',
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'assets/rook.svg',
    );
    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'assets/rook.svg',
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'assets/rook.svg',
    );
    //place knights
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'assets/knight.svg',
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'assets/knight.svg',
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'assets/knight.svg',
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'assets/knight.svg',
    );
    //place bishops
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'assets/bishop.svg',
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'assets/bishop.svg',
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'assets/bishop.svg',
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'assets/bishop.svg',
    );
    //place queen
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: 'assets/queen.svg',
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: 'assets/queen.svg',
    );
    //place king
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: 'assets/king.svg',
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: 'assets/king.svg',
    );
    board = newBoard;
  }

  //USER SELECTED A Piece
  void pieceSelected(int row, int col) {
    setState(() {
      //no piece has been selected yet,this is the first selection
      if (selectedPiece == null && board[row][col] != null) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      //there is a piece already selected,but the user selects another piece
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        log('true');
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      //if a piece is selected and the user taps on another square, move the piece
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }
      //if a piece is selected, calculate it's valid moves
      validMoves = calculateRawValidMoves(row, col, selectedPiece);
    });
  }

  //Calculate Raw Valid Moves
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];
    if (piece == null) {
      return [];
    }
    //different directions based on their color
    int direction = piece.isWhite ? -1 : 1;
    switch (piece.type) {
      case ChessPieceType.pawn:
        //pawn can move forward if square is empty
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        //pawn can move 2 squares forward at the start
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        //pawn can kill diagonally
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            !board[row + direction][col - 1]!.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            !board[row + direction][col + 1]!.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;
      case ChessPieceType.rook:
        //horizontal and vertical movement
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        ];
        //loop through all directions and check if there is a piece there
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        //knight moves in L shape
        var knightMoves = [
          [-2, -1], //up 2 left 1
          [-2, 1], //up 2 right 1
          [-1, -2], //up 1 left 2
          [-1, 2], //up 1 right 2
          [1, -2], //down 1 left 2
          [1, 2], //down 1 right 2
          [2, -1], //down 2 left 1
          [2, 1], //down 2 right 1
        ];
        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //kill
            }
            continue; //blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        //diagonal directions
        var directions = [
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill
              }
              break; //block
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        //horizontal and vertical and diagonal movement
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); //kill
              }
              break; //block
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        //all eight directions
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //kill
            }
            continue; //block
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
    }
    return candidateMoves;
  }

  //move
  void movePiece(int newRow, int newCol) {
    setState(() {
      //move the piece and clear the old spot
      board[newRow][newCol] = selectedPiece;
      board[selectedRow][selectedCol] = null;

      //reset the selected piece
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemBuilder: (context, index) {
              int row = index ~/ 8;
              int col = index % 8;

              //check if square is selected
              bool isSelected = selectedRow == row && selectedCol == col;

              //check if this square is a valid moves
              bool isValidMove = false;
              for (var position in validMoves) {
                //compare row and col
                if (position[0] == row && position[1] == col) {
                  isValidMove = true;
                }
              }
              return Square(
                isWhite: isWhite(index),
                piece: board[row][col],
                isSelected: isSelected,
                onTap: () => pieceSelected(row, col),
                isValidMoves: isValidMove,
              );
            },
            itemCount: 64,
          ),
        ),
      ),
    );
  }
}
