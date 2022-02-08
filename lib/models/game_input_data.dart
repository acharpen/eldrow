import 'package:eldrow/models/game_data.dart';

class GameInputData {
  final int playedGamesNumber;
  final List<String> words;
  final GameData? gameData;

  const GameInputData(
      {required this.playedGamesNumber, required this.words, this.gameData});
}
