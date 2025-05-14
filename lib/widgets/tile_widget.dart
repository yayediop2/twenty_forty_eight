import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/models/tile.dart';

class TileWidget extends StatelessWidget {
  const TileWidget({super.key, required this.tile, required this.theme});

  final Tile tile;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            tile.value != 0
                ? theme.colorScheme.primaryFixedDim
                : theme.colorScheme.secondary,

        border: Border.all(color: theme.colorScheme.onSurface, width: 3),
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
  }
}
