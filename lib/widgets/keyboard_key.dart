import 'package:eldrow/controllers/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyboardKey extends StatelessWidget {
  final Color backgroundColor;
  final Widget content;
  final double widthFactor;

  final _gameController = Get.put(GameController());

  KeyboardKey(
      {Key? key,
      required this.content,
      this.backgroundColor = const Color.fromRGBO(211, 214, 218, 1),
      this.widthFactor = 1.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0), color: backgroundColor),
        height: 58.0,
        margin: EdgeInsets.only(
            bottom: 4.0,
            left: _gameController.keyboardKeyXMargin,
            right: _gameController.keyboardKeyXMargin,
            top: 4.0),
        width: _gameController.getKeyboardKeyWidth(context, widthFactor),
        child: Center(child: content));
  }
}
