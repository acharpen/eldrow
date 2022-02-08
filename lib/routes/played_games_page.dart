import 'package:eldrow/controllers/game_controller.dart';
import 'package:eldrow/main.dart';
import 'package:eldrow/models/game_data.dart';
import 'package:eldrow/utils/game_storage.dart';
import 'package:eldrow/widgets/played_game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayedGamesPage extends StatefulWidget {
  const PlayedGamesPage({Key? key}) : super(key: key);

  @override
  State<PlayedGamesPage> createState() => _PlayedGamesPageState();
}

class _PlayedGamesPageState extends State<PlayedGamesPage> {
  final _gameController = Get.put(GameController());
  final _gameStorage = Get.put(GameStorage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop()),
            title: const Text(MyApp.title)),
        body: FutureBuilder<List<GameData>>(
            future: _gameStorage.loadPlayedGames(),
            builder:
                (BuildContext context, AsyncSnapshot<List<GameData>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Text('Aucune partie jouée.')]));
                } else {
                  final playedGames = snapshot.data!;
                  final playedGamesNumber = playedGames.length;
                  final wonGamesNumber =
                      playedGames.where((game) => game.isGameWin).length;

                  return Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${((wonGamesNumber / playedGamesNumber) * 100).truncate()} %',
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '$playedGamesNumber / ${_gameController.words.length}',
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))
                            ])),
                    const Divider(
                        color: Colors.grey,
                        endIndent: 16.0,
                        height: 1,
                        indent: 16.0),
                    Expanded(
                        child: ListView.builder(
                            itemCount: playedGamesNumber,
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (BuildContext context, int index) =>
                                PlayedGame(gameData: playedGames[index])))
                  ]);
                }
              } else if (snapshot.hasError) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                      Text('Erreur : impossible de charger les parties jouées.')
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
                          child: Text('Chargement des parties jouées...'))
                    ]));
              }
            }));
  }
}
