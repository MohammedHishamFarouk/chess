bool isWhite(int index) {
  int x = index ~/ 8; // find the row
  int y = index % 8; // find the column
  bool isWhite = (x + y) % 2 == 0;
  return isWhite;
}
