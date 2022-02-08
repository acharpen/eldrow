import 'package:eldrow/controllers/game_controller.dart';
import 'package:eldrow/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Board extends StatelessWidget {
  final _gameController = Get.put(GameController());

  Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var i = 0; i < _gameController.maximumNumberOfAttempts; i++)
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var j = 0; j < _gameController.wordToGuessLength; j++)
                    Tile(
                        tileData: _gameController
                            .board[i * _gameController.wordToGuessLength + j])
                ])
        ]));
  }
}
