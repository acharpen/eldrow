import 'package:eldrow/controllers/game_controller.dart';
import 'package:eldrow/models/letter_status.dart';
import 'package:eldrow/models/tile_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tile extends StatelessWidget {
  final TileData tileData;

  final _gameController = Get.put(GameController());

  Tile({Key? key, required this.tileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = _gameController.getTileSize(context);

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: _borderColor, width: 2.0),
            color: _backgroundColor),
        height: size,
        margin: EdgeInsets.all(_gameController.tileMargin),
        padding: const EdgeInsets.all(2.0),
        width: size,
        child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(tileData.letter,
                style: TextStyle(
                    color: _textColor, fontWeight: FontWeight.bold))));
  }

  Color get _backgroundColor {
    switch (tileData.letterStatus) {
      case LetterStatus.correct:
        return const Color.fromRGBO(106, 170, 100, 1);
      case LetterStatus.present:
        return const Color.fromRGBO(201, 180, 88, 1);
      case LetterStatus.absent:
        return const Color.fromRGBO(120, 124, 126, 1);
      case LetterStatus.none:
        return Colors.transparent;
    }
  }

  Color get _borderColor {
    return tileData.letterStatus == LetterStatus.correct
        ? const Color.fromRGBO(106, 170, 100, 1)
        : tileData.letterStatus == LetterStatus.present
            ? const Color.fromRGBO(201, 180, 88, 1)
            : tileData.letterStatus == LetterStatus.absent
                ? const Color.fromRGBO(120, 124, 126, 1)
                : tileData.letter != ''
                    ? const Color.fromRGBO(135, 138, 140, 1)
                    : const Color.fromRGBO(211, 214, 218, 1);
  }

  Color get _textColor {
    return tileData.letterStatus == LetterStatus.none
        ? const Color.fromRGBO(26, 26, 27, 1)
        : Colors.white;
  }
}
