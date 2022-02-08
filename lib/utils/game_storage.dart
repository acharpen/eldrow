import 'dart:async';

import 'package:eldrow/constants/hive_constants.dart';
import 'package:eldrow/models/game_data.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class GameStorage {
  void clearCurrentGame() async {
    final box = await Hive.openBox<GameData>(HiveConstants.currentGameBox);

    box.clear();
  }

  Future<int> getPlayedGamesNumber() async {
    final box = await Hive.openBox<GameData>(HiveConstants.playedGamesBox);

    return box.length;
  }

  Future<GameData?> loadCurrentGame() async {
    final box = await Hive.openBox<GameData>(HiveConstants.currentGameBox);

    return box.isEmpty ? null : box.values.first;
  }

  Future<List<GameData>> loadPlayedGames() async {
    final box = await Hive.openBox<GameData>(HiveConstants.playedGamesBox);

    return box.values.toList();
  }

  Future<List<String>> loadWords() async {
    final rawData = await rootBundle.loadString('assets/words.txt');

    return rawData.split('\n').toList();
  }

  void saveCurrentGame(GameData gameData) async {
    final box = await Hive.openBox<GameData>(HiveConstants.currentGameBox);

    box.clear();
    box.add(gameData);
  }

  void savePlayedGame(GameData gameData) async {
    final box = await Hive.openBox<GameData>(HiveConstants.playedGamesBox);

    box.add(gameData);
  }
}
