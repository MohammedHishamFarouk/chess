class Moves {
  //horizontal and vertical movement
  static const List<List<int>> rook = [
    [-1, 0], //up
    [1, 0], //down
    [0, -1], //left
    [0, 1], //right
  ];
  //knight moves in L shape
  static const List<List<int>> knight = [
    [-2, -1], //up 2 left 1
    [-2, 1], //up 2 right 1
    [-1, -2], //up 1 left 2
    [-1, 2], //up 1 right 2
    [1, -2], //down 1 left 2
    [1, 2], //down 1 right 2
    [2, -1], //down 2 left 1
    [2, 1], //down 2 right 1
  ];
  //diagonal directions
  static const List<List<int>> bishop = [
    [-1, -1], //up left
    [-1, 1], //up right
    [1, -1], //down left
    [1, 1], //down right
  ];
  //horizontal and vertical and diagonal movement
  static const List<List<int>> queen = [
    [-1, 0], //up
    [1, 0], //down
    [0, -1], //left
    [0, 1], //right
    [-1, -1], //up left
    [-1, 1], //up right
    [1, -1], //down left
    [1, 1], //down right
  ];
  //all eight directions
  static const List<List<int>> king = [
    [-1, 0], //up
    [1, 0], //down
    [0, -1], //left
    [0, 1], //right
    [-1, -1], //up left
    [-1, 1], //up right
    [1, -1], //down left
    [1, 1], //down right
  ];
}
