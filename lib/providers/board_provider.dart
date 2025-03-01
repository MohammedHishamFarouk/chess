import 'package:chess/components/piece.dart';
import 'package:chess/helper/constants.dart';
import 'package:chess/helper/functions.dart';
import 'package:flutter/material.dart';

class BoardProvider extends ChangeNotifier {
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

  //list of white pieces that have been taken by the black side
  List<ChessPiece> whitePiecesTaken = [];

  //list of black pieces that have been taken by the white side
  List<ChessPiece> blackPiecesTaken = [];

  //A boolean to indicate whose turn it is
  bool isWhiteTurn = true;
  //keep track of the kings position to make it easier to check for checkmate
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  void initializeBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));
    // Place pawns
    placePawns(newBoard);
    // Place rooks
    placeRooks(newBoard);
    // Place knights
    placeKnights(newBoard);
    // Place bishops
    placeBishops(newBoard);
    // Place queens
    placeQueens(newBoard);
    // Place kings
    placeKings(newBoard);

    board = newBoard;
  }

  //USER SELECTED A Piece
  void pieceSelected(int row, int col, BuildContext context) {
    //no piece has been selected yet,this is the first selection
    if (selectedPiece == null && board[row][col] != null) {
      if (board[row][col]!.isWhite == isWhiteTurn) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
    }
    //there is a piece already selected,but the user selects another piece
    else if (board[row][col] != null &&
        board[row][col]!.isWhite == selectedPiece!.isWhite) {
      selectedPiece = board[row][col];
      selectedRow = row;
      selectedCol = col;
    }
    //if a piece is selected and the user taps on another square, move the piece
    else if (selectedPiece != null &&
        validMoves.any((element) => element[0] == row && element[1] == col)) {
      movePiece(row, col, context);
    }
    //if a piece is selected and the user taps on an empty square, cancel selection
    else {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    }
    //if a piece is selected, calculate it's valid moves
    validMoves = calculateRealValidMoves(row, col, selectedPiece, true);
  }

  //Calculate Raw Valid Moves
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];
    if (piece == null) return [];

    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        _pawnMoves(row, col, piece, direction, candidateMoves);
        break;
      case ChessPieceType.rook:
        _slidingMoves(row, col, piece, Moves.rook, candidateMoves);
        break;
      case ChessPieceType.knight:
        _lShapeMoves(row, col, piece, Moves.knight, candidateMoves);
        break;
      case ChessPieceType.bishop:
        _slidingMoves(row, col, piece, Moves.bishop, candidateMoves);
        break;
      case ChessPieceType.queen:
        _slidingMoves(row, col, piece, Moves.queen, candidateMoves);
        break;
      case ChessPieceType.king:
        _lShapeMoves(row, col, piece, Moves.king, candidateMoves);
        break;
    }

    notifyListeners();
    return candidateMoves;
  }

  void _pawnMoves(int row, int col, ChessPiece piece, int direction,
      List<List<int>> candidateMoves) {
    // Pawn move forward one square
    if (isInBoard(row + direction, col) &&
        board[row + direction][col] == null) {
      candidateMoves.add([row + direction, col]);
    }

    // Pawn initial 2-square move
    if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
      if (isInBoard(row + 2 * direction, col) &&
          board[row + 2 * direction][col] == null &&
          board[row + direction][col] == null) {
        candidateMoves.add([row + 2 * direction, col]);
      }
    }

    // Pawn captures diagonally
    _captureMoves(row, col, piece, direction, candidateMoves);
  }

  void _captureMoves(int row, int col, ChessPiece piece, int direction,
      List<List<int>> candidateMoves) {
    // Check diagonal captures (left and right)
    if (isInBoard(row + direction, col - 1) &&
        board[row + direction][col - 1] != null &&
        board[row + direction][col - 1]!.isWhite != piece.isWhite) {
      candidateMoves.add([row + direction, col - 1]);
    }
    if (isInBoard(row + direction, col + 1) &&
        board[row + direction][col + 1] != null &&
        board[row + direction][col + 1]!.isWhite != piece.isWhite) {
      candidateMoves.add([row + direction, col + 1]);
    }
  }

  void _slidingMoves(int row, int col, ChessPiece piece,
      List<List<int>> directions, List<List<int>> candidateMoves) {
    for (var direction in directions) {
      var i = 1;
      while (true) {
        var newRow = row + i * direction[0];
        var newCol = col + i * direction[1];
        if (!isInBoard(newRow, newCol)) break;
        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != piece.isWhite) {
            candidateMoves.add([newRow, newCol]); // capture
          }
          break; // blocked
        }
        candidateMoves.add([newRow, newCol]);
        i++;
      }
    }
  }

  void _lShapeMoves(int row, int col, ChessPiece piece,
      List<List<int>> directions, List<List<int>> candidateMoves) {
    for (var direction in directions) {
      var newRow = row + direction[0];
      var newCol = col + direction[1];
      if (!isInBoard(newRow, newCol)) continue;
      if (board[newRow][newCol] != null) {
        if (board[newRow][newCol]!.isWhite != piece.isWhite) {
          candidateMoves.add([newRow, newCol]); // capture
        }
        continue; // blocked
      }
      candidateMoves.add([newRow, newCol]);
    }
  }

  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);
    //after generating all candidate moves, filter out any that could result in a check
    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        //this will simulate future move to see if its safe
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  //Move Piece
  void movePiece(int newRow, int newCol, BuildContext context) {
    // Capture piece if any
    var capturedPiece = board[newRow][newCol];
    if (capturedPiece != null) {
      (capturedPiece.isWhite ? whitePiecesTaken : blackPiecesTaken)
          .add(capturedPiece);
    }

    // Update king position if needed
    if (selectedPiece!.type == ChessPieceType.king) {
      selectedPiece!.isWhite
          ? whiteKingPosition = [newRow, newCol]
          : blackKingPosition = [newRow, newCol];
    }

    // Move the piece
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    // Check for check status
    checkStatus = isKingInCheck(!isWhiteTurn);

    // Reset selected piece info
    selectedPiece = null;
    selectedRow = -1;
    selectedCol = -1;
    validMoves = [];

    // Handle checkmate
    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Check Mate'),
          actions: [
            TextButton(
                onPressed: () => resetGame(context), child: Text('Play Again')),
          ],
        ),
      );
    }

    // Switch turns
    isWhiteTurn = !isWhiteTurn;
  }

  //is King in Check??
  bool isKingInCheck(bool isWhiteKing) {
    //get the king position
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;
    //check is any piece can kill the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //skip empty squares and pieces of the same color as the king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);
        //check if the king is in one of the piece's valid moves
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  //Simulate future move to see if its safe for our king
  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    //save the current board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];
    //if the piece is a king,save its current position and update the new position
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;
      //update the king position
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    //simulate the move
    board[startRow][startCol] = null;
    board[endRow][endCol] = piece;

    //check if our King is under attack
    bool kingInCheck = isKingInCheck(piece.isWhite);

    //restore the board to original state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    //if the king is in check == true, then this move is not safe == false
    return !kingInCheck;
  }

  bool isCheckMate(bool isWhiteKing) {
    // if the king is not in check, then it's not checkmate
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }

    //if there is at least one legal move for any of the player's pieces, then it's not checkmate
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //skip empty squares and pieces of the other color
        if (board[i][j] != null && board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], true);
        //if this list has any valid moves then it's not checkmate
        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }
    //if none of the above conditions are meet then it's checkmate
    return true;
  }

  //reset the game
  void resetGame(BuildContext context) {
    Navigator.pop(context);
    initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    notifyListeners();
  }
}
