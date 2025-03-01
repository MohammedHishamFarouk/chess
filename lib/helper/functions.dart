import 'package:chess/components/piece.dart';

bool isWhite(int index) {
  int x = index ~/ 8; // find the row
  int y = index % 8; // find the column
  bool isWhite = (x + y) % 2 == 0;
  return isWhite;
}

bool isInBoard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}

void placePawns(List<List<ChessPiece?>> board) {
  for (int i = 0; i < 8; i++) {
    board[1][i] = ChessPiece(
      type: ChessPieceType.pawn,
      isWhite: false,
      imagePath: 'assets/pawn.svg',
    );
    board[6][i] = ChessPiece(
      type: ChessPieceType.pawn,
      isWhite: true,
      imagePath: 'assets/pawn.svg',
    );
  }
}

void placeRooks(List<List<ChessPiece?>> board) {
  _placePiece(board, 0, 0, ChessPieceType.rook, false, 'assets/rook.svg');
  _placePiece(board, 0, 7, ChessPieceType.rook, false, 'assets/rook.svg');
  _placePiece(board, 7, 0, ChessPieceType.rook, true, 'assets/rook.svg');
  _placePiece(board, 7, 7, ChessPieceType.rook, true, 'assets/rook.svg');
}

void placeKnights(List<List<ChessPiece?>> board) {
  _placePiece(board, 0, 1, ChessPieceType.knight, false, 'assets/knight.svg');
  _placePiece(board, 0, 6, ChessPieceType.knight, false, 'assets/knight.svg');
  _placePiece(board, 7, 1, ChessPieceType.knight, true, 'assets/knight.svg');
  _placePiece(board, 7, 6, ChessPieceType.knight, true, 'assets/knight.svg');
}

void placeBishops(List<List<ChessPiece?>> board) {
  _placePiece(board, 0, 2, ChessPieceType.bishop, false, 'assets/bishop.svg');
  _placePiece(board, 0, 5, ChessPieceType.bishop, false, 'assets/bishop.svg');
  _placePiece(board, 7, 2, ChessPieceType.bishop, true, 'assets/bishop.svg');
  _placePiece(board, 7, 5, ChessPieceType.bishop, true, 'assets/bishop.svg');
}

void placeQueens(List<List<ChessPiece?>> board) {
  _placePiece(board, 0, 3, ChessPieceType.queen, false, 'assets/queen.svg');
  _placePiece(board, 7, 3, ChessPieceType.queen, true, 'assets/queen.svg');
}

void placeKings(List<List<ChessPiece?>> board) {
  _placePiece(board, 0, 4, ChessPieceType.king, false, 'assets/king.svg');
  _placePiece(board, 7, 4, ChessPieceType.king, true, 'assets/king.svg');
}

void _placePiece(List<List<ChessPiece?>> board, int row, int col,
    ChessPieceType type, bool isWhite, String imagePath) {
  board[row][col] = ChessPiece(
    type: type,
    isWhite: isWhite,
    imagePath: imagePath,
  );
}
