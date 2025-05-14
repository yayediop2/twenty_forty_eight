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
