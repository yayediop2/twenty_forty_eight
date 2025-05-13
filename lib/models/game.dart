class Board {
  final int row;
  final int col;

  Board({required this.row, required this.col});
}

class Tile {
  int x, y;
  int value;

  Tile({required this.x, required this.y, required this.value});
}
