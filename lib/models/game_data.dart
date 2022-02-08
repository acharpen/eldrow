import 'package:hive/hive.dart';

part 'game_data.g.dart';

@HiveType(typeId: 0)
class GameData extends HiveObject {
  @HiveField(0)
  final String word;
  @HiveField(1)
  final List<String> attempts;

  GameData({required this.attempts, required this.word}) : super();

  bool get isGameWin {
    return attempts[attempts.length - 1] == word;
  }

  int get numberOfAttempts {
    return attempts.length;
  }
}
