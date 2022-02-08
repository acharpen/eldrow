import 'package:eldrow/controllers/game_controller.dart';
import 'package:eldrow/widgets/board.dart';
import 'package:eldrow/widgets/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Game extends StatelessWidget {
  final _gameController = Get.put(GameController());

  Game({Key? key, required gameInputData}) : super(key: key) {
    _gameController.init(gameInputData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(_gameController.gameMargin),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              height: 50.0,
              child: Obx(() {
                if (_gameController.haveAllWordsBeenFound.value) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: const Color.fromRGBO(26, 26, 27, 1)),
                            padding: const EdgeInsets.all(16.0),
                            child: const Text(
                                'Félicitations, vous avez deviné tous les mots !',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0)))
                      ]);
                } else if (_gameController.isGameEnded.value) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: const Color.fromRGBO(26, 26, 27, 1)),
                            padding: const EdgeInsets.all(16.0),
                            child: Text(_gameController.wordToGuess,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold))),
                        GestureDetector(
                            onTap: () => _gameController.newGame(),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            26, 26, 27, 1)),
                                    borderRadius: BorderRadius.circular(4.0)),
                                padding: const EdgeInsets.all(16.0),
                                child: const Text('Suivant',
                                    style: TextStyle(
                                        color: Color.fromRGBO(26, 26, 27, 1),
                                        fontSize: 16.0))))
                      ]);
                } else {
                  return Row(children: const []);
                }
              })),
          Expanded(child: Board()),
          Keyboard()
        ])));
  }
}
