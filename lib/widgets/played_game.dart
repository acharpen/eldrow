import 'package:eldrow/models/game_data.dart';
import 'package:flutter/material.dart';

class PlayedGame extends StatelessWidget {
  final GameData gameData;

  const PlayedGame({Key? key, required this.gameData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
          title: Text(gameData.word,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Visibility(
              visible: gameData.isGameWin,
              child: Text(
                  '${gameData.numberOfAttempts} coup${gameData.numberOfAttempts > 1 ? 's' : ''}')),
          leading: gameData.isGameWin
              ? const Icon(Icons.done,
                  color: Color.fromRGBO(106, 170, 100, 1), size: 30.0)
              : const Icon(Icons.clear, color: Colors.red, size: 30.0))
    ]);
  }
}
