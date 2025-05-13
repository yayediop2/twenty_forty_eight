class Board {
  final int row;
  final int col;

  late List<List<Tile>> gameboard;
  
  Board({required this.row, required this.col}){
    initBoard();
  }


  void initBoard() {
    gameboard = List.generate(row, (r) {
      return List.generate(col, (c) {
        return Tile(x: r, y: c, value: 0, isMerged: false);
      });
    });
  }

  Tile getTile(int r, int c) {
    return gameboard[r][c];
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
}
