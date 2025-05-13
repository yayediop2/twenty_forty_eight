import 'dart:math';

import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/models/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const gameTitle = '2048';

    return MaterialApp(
      title: gameTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: MyHomePage(title: '2048 GAME'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Board board;
  final Random randomNum = Random();

  void onSwipeLeft() {
    print('swipe left');
  }

  void onSwipeRight() {
    print('swipe right');
  }

  void onSwipeUp() {
    print('swipe up');
  }

  void onSwipeDown() {
    print('swipe down');
  }

  @override
  void initState() {
    super.initState();

    board = Board(row: 4, col: 4)..initBoard();
    // nextInt(2) donne soit 0 ou 1
    int initialNumTiles = 3 + randomNum.nextInt(2);
    _generateRandomTiles(initialNumTiles);
  }

  void _generateRandomTiles(int count) {
    final allEmptyTiles = <Tile>[];
    for (var row in board.gameboard) {
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
                const NeverScrollableScrollPhysics(), // disables scrolling so swipe up ad down can work
            shrinkWrap: true, // makes GridView size properly inside Center
            crossAxisCount: 4,
            children: List.generate(16, (index) {
              int x = index % 4;
              int y = index ~/ 4;
              final tile = board.getTile(y, x);

              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      tile.value != 0
                          ? theme.colorScheme.primaryFixedDim
                          : theme.colorScheme.secondary,

                  border: Border.all(
                    color: theme.colorScheme.onSurface,
                    width: 3,
                  ),
                ),
                child:
                    tile.value != 0
                        ? Text(
                          tile.value.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                        : null,
              );
            }),
          ),
        ),
      ),
    );
  }
}
