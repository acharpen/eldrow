import 'package:eldrow/main.dart';
import 'package:eldrow/models/game_input_data.dart';
import 'package:eldrow/routes/played_games_page.dart';
import 'package:eldrow/utils/game_storage.dart';
import 'package:eldrow/widgets/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _gameStorage = Get.put(GameStorage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(MyApp.title), actions: [
          IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => Get.to(() => const PlayedGamesPage()))
        ]),
        body: FutureBuilder<GameInputData>(
            future: _loadGameInput(),
            builder:
                (BuildContext context, AsyncSnapshot<GameInputData> snapshot) {
              if (snapshot.hasData) {
                return Game(gameInputData: snapshot.data!);
              } else if (snapshot.hasError) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                      Text('Erreur : impossible de charger les données.')
                    ]));
              } else {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                      SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: CircularProgressIndicator()),
                      Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text('Chargement des données...'))
                    ]));
              }
            }));
  }

  Future<GameInputData> _loadGameInput() async {
    final currentGameData = await _gameStorage.loadCurrentGame();
    final playedGamesNumber = await _gameStorage.getPlayedGamesNumber();
    final words = await _gameStorage.loadWords();

    return GameInputData(
        playedGamesNumber: playedGamesNumber,
        words: words,
        gameData: currentGameData);
  }
}
