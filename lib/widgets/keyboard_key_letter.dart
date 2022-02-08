import 'package:eldrow/controllers/game_controller.dart';
import 'package:eldrow/models/letter_status.dart';
import 'package:eldrow/widgets/keyboard_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyboardKeyLetter extends StatelessWidget {
  final String letter;

  final _gameController = Get.put(GameController());

  KeyboardKeyLetter({Key? key, required this.letter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _handlePushLetter,
        child: Obx(() => KeyboardKey(
            backgroundColor: _backgroundColor,
            content: Text(letter,
                style: TextStyle(
                    color: _textColor, fontWeight: FontWeight.bold)))));
  }

  Color get _backgroundColor {
    switch (_gameController.keyboard[letter] ?? LetterStatus.none) {
      case LetterStatus.correct:
        return const Color.fromRGBO(106, 170, 100, 1);
      case LetterStatus.present:
        return const Color.fromRGBO(201, 180, 88, 1);
      case LetterStatus.absent:
        return const Color.fromRGBO(135, 138, 140, 1);
      case LetterStatus.none:
        return const Color.fromRGBO(211, 214, 218, 1);
    }
  }

  Color get _textColor {
    return (_gameController.keyboard[letter] ?? LetterStatus.none) ==
            LetterStatus.none
        ? const Color.fromRGBO(26, 26, 27, 1)
        : Colors.white;
  }

  void _handlePushLetter() {
    if (_gameController.canTapKey) {
      _gameController.pushLetter(letter);
    }
  }
}
