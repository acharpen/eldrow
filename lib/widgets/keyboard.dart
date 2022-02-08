import 'package:eldrow/controllers/game_controller.dart';
import 'package:eldrow/widgets/keyboard_key.dart';
import 'package:eldrow/widgets/keyboard_key_letter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Keyboard extends StatelessWidget {
  final _gameController = Get.put(GameController());

  Keyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            KeyboardKeyLetter(letter: 'A'),
            KeyboardKeyLetter(letter: 'Z'),
            KeyboardKeyLetter(letter: 'E'),
            KeyboardKeyLetter(letter: 'R'),
            KeyboardKeyLetter(letter: 'T'),
            KeyboardKeyLetter(letter: 'Y'),
            KeyboardKeyLetter(letter: 'U'),
            KeyboardKeyLetter(letter: 'I'),
            KeyboardKeyLetter(letter: 'O'),
            KeyboardKeyLetter(letter: 'P')
          ]),
      Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            KeyboardKeyLetter(letter: 'Q'),
            KeyboardKeyLetter(letter: 'S'),
            KeyboardKeyLetter(letter: 'D'),
            KeyboardKeyLetter(letter: 'F'),
            KeyboardKeyLetter(letter: 'G'),
            KeyboardKeyLetter(letter: 'H'),
            KeyboardKeyLetter(letter: 'J'),
            KeyboardKeyLetter(letter: 'K'),
            KeyboardKeyLetter(letter: 'L'),
            KeyboardKeyLetter(letter: 'M')
          ]),
      Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            KeyboardKeyLetter(letter: 'W'),
            KeyboardKeyLetter(letter: 'X'),
            KeyboardKeyLetter(letter: 'C'),
            KeyboardKeyLetter(letter: 'V'),
            KeyboardKeyLetter(letter: 'B'),
            KeyboardKeyLetter(letter: 'N'),
            GestureDetector(
                onTap: () => _handleValidateWord(context),
                child: KeyboardKey(
                    backgroundColor: const Color.fromRGBO(26, 115, 233, 1),
                    content: const Icon(Icons.check_outlined,
                        color: Colors.white, size: 24.0),
                    widthFactor: 1.5)),
            GestureDetector(
                onTap: _handlePopLetter,
                child: KeyboardKey(
                    backgroundColor: const Color.fromRGBO(26, 115, 233, 1),
                    content: const Icon(Icons.backspace_outlined,
                        color: Colors.white, size: 24.0),
                    widthFactor: 1.5))
          ])
    ]);
  }

  void _handlePopLetter() {
    if (_gameController.canTapKey) {
      _gameController.popLetter();
    }
  }

  void _handleValidateWord(BuildContext context) {
    if (_gameController.canTapKey) {
      if (!_gameController.isWordComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Le mot proposé est trop court.')));
      } else if (!_gameController.isWordValid) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Le mot n'existe pas dans le dictionnaire.")));
      } else {
        _gameController.validateWord();
      }
    }
  }
}
