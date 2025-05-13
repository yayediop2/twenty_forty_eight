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
  final List<Tile> tiles = [];
  final Random randomNum = Random();

  Tile? tileAt(int x, int y) {
    for (var tile in tiles) {
      if (tile.x == x && tile.y == y) return tile;
    }
    return null;
  }

  void _generateInitialTiles() {
    int tileCount =
        3 +
        randomNum.nextInt(2); // so the num generated is between 2 and 3 inclus

    while (tiles.length < tileCount) {
      int x = randomNum.nextInt(
        4,
      ); // so the coordinate num generated is between 0 and 4 inclus
      int y = randomNum.nextInt(4);

      if (tileAt(x, y) == null) {
        int value = randomNum.nextDouble() < 0.9 ? 2 : 4;
        tiles.add(Tile(x: x, y: y, value: value));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _generateInitialTiles();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: GridView.count(
          crossAxisCount: 4,
          children: List.generate(16, (index) {
            int x = index % 4;
            int y = index ~/ 4;
            Tile? tile = tileAt(x, y);

            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    tile != null
                        ? theme.colorScheme.primaryFixedDim
                        : theme.colorScheme.secondary,

                border: Border.all(
                  color: theme.colorScheme.onSurface,
                  width: 3,
                ),
              ),
              child:
                  tile != null
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
    );
  }
}
