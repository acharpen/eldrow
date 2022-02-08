import 'package:eldrow/constants/hive_constants.dart';
import 'package:eldrow/models/game_data.dart';
import 'package:eldrow/routes/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  Hive.registerAdapter(GameDataAdapter());

  await Hive.initFlutter();
  await Hive.openBox<GameData>(HiveConstants.currentGameBox);
  await Hive.openBox<GameData>(HiveConstants.playedGamesBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const title = "Eldrow";

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        home: const MyHomePage(),
        theme: ThemeData(),
        themeMode: ThemeMode.system,
        title: title);
  }
}
