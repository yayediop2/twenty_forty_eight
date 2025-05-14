import 'dart:math';

import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/models/board.dart';
import 'package:twenty_forty_eight/widgets/tile_widget.dart';
import '../models/tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Board gameBoard;
  final int rows = 4;
  final int columns = 4;
  final Random randomNum = Random();

  void onSwipeLeft() {
    if (!canMoveLeft()) return;

    setState(() {
      for (var r = 0; r < rows; r++) {
        for (var c = 0; c < columns; c++) {
          mergeLeft(r, c);
        }
      }
      _generateRandomTiles(1);
      _resetMergeFlags();
    });
  }

  void onSwipeRight() {
    if (!canMoveRight()) {
      return;
    }
    setState(() {
      for (int r = 0; r < rows; r++) {
        for (int c = columns - 2; c >= 0; c--) {
          mergeRight(r, c);
        }
      }
      _generateRandomTiles(1);
      _resetMergeFlags();
    });
  }

  void onSwipeUp() {
    if (!canMoveUp()) {
      return;
    }

    setState(() {
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < columns; c++) {
          mergeUp(r, c);
        }
      }
      _generateRandomTiles(1);
      _resetMergeFlags();
    });
  }

  void onSwipeDown() {
    if (!canMoveDown()) {
      return;
    }

    setState(() {
      for (int r = rows - 2; r >= 0; r--) {
        for (int c = 0; c < columns; c++) {
          mergeDown(r, c);
        }
      }
      _generateRandomTiles(1);
      _resetMergeFlags();
    });
  }

  @override
  void initState() {
    super.initState();

    gameBoard = Board(row: rows, col: columns)..initBoard();
    // nextInt(2) donne soit 0 ou 1
    int initialNumTiles = 3 + randomNum.nextInt(2);
    _generateRandomTiles(initialNumTiles);
  }

  void _generateRandomTiles(int count) {
    final allEmptyTiles = <Tile>[];
    for (var row in gameBoard.gameBoard) {
      for (var singleTile in row) {
        if (singleTile.value == 0) {
          allEmptyTiles.add(singleTile);
        }
      }
    }

    if (allEmptyTiles.isEmpty) {
      return;
    }

    allEmptyTiles.shuffle();

    for (var i = 0; i < count && i < allEmptyTiles.length; i++) {
      allEmptyTiles[i].value = randomNum.nextBool() ? 2 : 4;
    }
  }

  bool canMerge(Tile a, Tile b) {
    return !a.isMerged &&
        ((a.isEmpty() && !b.isEmpty() || (!b.isEmpty() && a.value == b.value)));
  }

  void merge(Tile a, Tile b) {
    // case eg when a 2 and b 4 (different values)
    if (!canMerge(a, b)) {
      if (!a.isMerged && !b.isEmpty()) {
        a.isMerged = true;
      }
      return;
    }

    // case eg when merging b 2 onto an empty cell a
    if (a.isEmpty()) {
      a.value = b.value;
      b.value = 0;
      // case eg when a and b have same value
    } else if (a.value == b.value && !a.isMerged) {
      a.value = a.value + b.value;
      b.value = 0;
      a.isMerged = true;
      // case every other scenario
    } else {
      a.isMerged = true;
    }
  }

  void mergeLeft(int r, int c) {
    // Eg. Merging d with c, then with b, then with a. Pushing the value daal to the very left
    while (c > 0) {
      merge(gameBoard.getTile(r, c - 1), gameBoard.getTile(r, c));
      c -= 1;
    }
  }

  void mergeRight(int r, int c) {
    // Eg.  Merging c with d, then b with c with d etc. Pushing the value daal to the very right
    while (c < columns - 1) {
      merge(gameBoard.getTile(r, c + 1), gameBoard.getTile(r, c));
      c += 1;
    }
  }

  void mergeUp(int r, int c) {
    while (r > 0) {
      merge(gameBoard.getTile(r - 1, c), gameBoard.getTile(r, c));
      r -= 1;
    }
  }

  void mergeDown(int r, int c) {
    while (r < rows - 1) {
      merge(gameBoard.getTile(r + 1, c), gameBoard.getTile(r, c));
      r += 1;
    }
  }

  bool canMoveLeft() {
    for (int r = 0; r < rows; r++) {
      // c shouldn't start at 0
      for (int c = 1; c < columns; c++) {
        Tile current = gameBoard.getTile(r, c);
        Tile left = gameBoard.getTile(r, c - 1);

        if (!current.isEmpty()) {
          // can move to empty space or merge with same value
          if (left.isEmpty() || left.value == current.value) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int r = 0; r < rows; r++) {
      // Iterate in the opposite direction from right to left
      for (int c = columns - 2; c >= 0; c--) {
        if (canMerge(gameBoard.getTile(r, c + 1), gameBoard.getTile(r, c))) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int r = 1; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        if (canMerge(gameBoard.getTile(r - 1, c), gameBoard.getTile(r, c))) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveDown() {
    for (int r = rows - 2; r >= 0; r--) {
      for (int c = 0; c < columns; c++) {
        if (canMerge(gameBoard.getTile(r + 1, c), gameBoard.getTile(r, c))) {
          return true;
        }
      }
    }
    return false;
  }

  void _resetMergeFlags() {
    for (var row in gameBoard.gameBoard) {
      for (var tile in row) {
        tile.isMerged = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            onSwipeRight();
          } else {
            onSwipeLeft();
          }
        },
        onVerticalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dy > 0) {
            onSwipeDown();
          } else {
            onSwipeUp();
          }
        },
        child: Center(
          child: GridView.count(
            physics:
                const NeverScrollableScrollPhysics(), // disables scrolling so swipe up and down can work
            shrinkWrap: true, // makes GridView size properly inside Center
            crossAxisCount: 4,
            children: List.generate(16, (index) {
              int x = index % columns;
              int y = index ~/ rows;
              final tile = gameBoard.getTile(y, x);

              return TileWidget(tile: tile, theme: theme);
            }),
          ),
        ),
      ),
    );
  }
}
