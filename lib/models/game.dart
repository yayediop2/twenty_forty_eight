class Board {
  final int row;
  final int col;

  late List<List<Tile>> gameBoard;

  Board({required this.row, required this.col}) {
    initBoard();
  }

  void initBoard() {
    gameBoard = List.generate(row, (r) {
      return List.generate(col, (c) {
        return Tile(x: r, y: c, value: 0, isMerged: false);
      });
    });
  }

  Tile getTile(int r, int c) {
    return gameBoard[r][c];
  }
}

class Tile {
  int x, y;
  int value;
  bool isMerged;

  Tile({
    required this.x,
    required this.y,
    required this.value,
    required this.isMerged,
  });

  bool isEmpty() {
    return value == 0;
  }
}
