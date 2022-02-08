import 'dart:math';

import 'package:eldrow/models/game_data.dart';
import 'package:eldrow/models/game_input_data.dart';
import 'package:eldrow/models/letter_status.dart';
import 'package:eldrow/models/tile_data.dart';
import 'package:eldrow/utils/game_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  final _gameStorage = Get.put(GameStorage());
  final _maximumNumberOfAttempts = 6;

  var board = <TileData>[].obs;
  var haveAllWordsBeenFound = false.obs;
  var isGameEnded = false.obs;
  var keyboard = <String, LetterStatus>{}.obs;

  var _boardColumnIndex = 0;
  var _boardRowIndex = 0;
  var _playedGamesNumber = 0;
  var _words = <String>[];
  var _wordToGuess = '';
  var _wordToGuessLength = 0;

  bool get canTapKey {
    return !isGameEnded.value && !haveAllWordsBeenFound.value;
  }

  double get gameMargin {
    return 8.0;
  }

  bool get isWordValid {
    return _words.contains(_currentWord);
  }

  bool get isWordComplete {
    return board[_boardRowIndex * _wordToGuessLength + _wordToGuessLength - 1]
            .letter !=
        '';
  }

  double get keyboardKeyXMargin {
    return 3.0;
  }

  int get maximumNumberOfAttempts {
    return _maximumNumberOfAttempts;
  }

  double get tileMargin {
    return 2.5;
  }

  List<String> get words {
    return _words;
  }

  String get wordToGuess {
    return _wordToGuess;
  }

  int get wordToGuessLength {
    return _wordToGuessLength;
  }

  double getKeyboardKeyWidth(BuildContext context, double widthFactor) {
    return min(
            43.0, (_getAvailableWidth(context) / 10 - 2 * keyboardKeyXMargin)) *
        widthFactor;
  }

  double getTileSize(BuildContext context) {
    return min(62.0,
        (_getAvailableWidth(context) / _wordToGuessLength - 2 * tileMargin));
  }

  void init(GameInputData gameInputData) {
    _playedGamesNumber = gameInputData.playedGamesNumber;
    _words = gameInputData.words;
    _wordToGuess = gameInputData.gameData?.word ?? _pickWordToGuess();
    _wordToGuessLength = _wordToGuess.length;

    haveAllWordsBeenFound.value = _playedGamesNumber == words.length;

    _initBoard();
    _initKeyboard();

    if (gameInputData.gameData != null) {
      _updateBoardAndKeyboardAgainstPreviousAttempts(
          gameInputData.gameData!.attempts);
    }
  }

  void newGame() {
    _boardColumnIndex = 0;
    _boardRowIndex = 0;
    _playedGamesNumber++;
    _wordToGuess = _pickWordToGuess();
    _wordToGuessLength = _wordToGuess.length;

    haveAllWordsBeenFound.value = _playedGamesNumber == words.length;
    isGameEnded.value = false;

    _initBoard();
    _initKeyboard();
  }

  void popLetter() {
    if (_boardColumnIndex > 0) {
      _boardColumnIndex--;

      _setBoardCurrentLetter('');
    }
  }

  void pushLetter(String letter) {
    if (_boardColumnIndex < _wordToGuessLength) {
      _setBoardCurrentLetter(letter);

      _boardColumnIndex++;
    }
  }

  void validateWord() {
    if (_boardRowIndex < _maximumNumberOfAttempts) {
      _updateBoardAndKeyboardAgainstCurrentAttempt();

      if (_currentWord == _wordToGuess ||
          (_boardRowIndex + 1) == _maximumNumberOfAttempts) {
        _gameStorage.clearCurrentGame();
        _gameStorage.savePlayedGame(_createGameData());

        isGameEnded.value = true;
      } else {
        _gameStorage.saveCurrentGame(_createGameData());

        _boardColumnIndex = 0;
        _boardRowIndex++;
      }
    }
  }

  GameData _createGameData() {
    List<String> attempts = [];
    for (var i = 0; i < _boardRowIndex + 1; i++) {
      var attempt = StringBuffer();
      for (var j = 0; j < _wordToGuessLength; j++) {
        attempt.write(board[i * _wordToGuessLength + j].letter);
      }

      attempts.add(attempt.toString());
    }

    return GameData(attempts: attempts, word: _wordToGuess);
  }

  String get _currentWord {
    return _currentWordTiles.map((tileData) => tileData.letter).join();
  }

  List<TileData> get _currentWordTiles {
    return board.sublist(_boardRowIndex * _wordToGuessLength,
        (_boardRowIndex + 1) * _wordToGuessLength);
  }

  double _getAvailableWidth(BuildContext context) {
    return MediaQuery.of(context).size.width - 2 * gameMargin;
  }

  void _initBoard() {
    board.value = List.generate(_maximumNumberOfAttempts * _wordToGuessLength,
        (_) => TileData(letter: ''));
  }

  void _initKeyboard() {
    Map<String, LetterStatus> _keyboard = {};
    for (var i = 'a'.codeUnitAt(0); i <= 'z'.codeUnitAt(0); i++) {
      _keyboard[String.fromCharCode(i)] = LetterStatus.none;
    }

    keyboard.value = _keyboard;
  }

  String _pickWordToGuess() {
    return _playedGamesNumber < words.length ? words[_playedGamesNumber] : '';
  }

  void _setBoardCurrentLetter(String letter) {
    board[_boardRowIndex * _wordToGuessLength + _boardColumnIndex] =
        TileData(letter: letter);
  }

  void _setKeyboardLetterStatus(String letter, LetterStatus letterStatus) {
    if (letterStatus.id > (keyboard[letter] ?? LetterStatus.none).id) {
      keyboard[letter] = letterStatus;
    }
  }

  void _updateBoardAndKeyboardAgainstCurrentAttempt() {
    for (var i = 0; i < _wordToGuessLength; i++) {
      final letterIndex = _boardRowIndex * _wordToGuessLength + i;
      final letter = board[letterIndex].letter;

      if (_wordToGuess[i] == letter) {
        board[letterIndex] =
            TileData(letter: letter, letterStatus: LetterStatus.correct);

        _setKeyboardLetterStatus(letter, LetterStatus.correct);
      }
    }

    for (var i = 0; i < _wordToGuessLength; i++) {
      final letterIndex = _boardRowIndex * _wordToGuessLength + i;

      if (board[letterIndex].letterStatus != LetterStatus.correct) {
        final letter = board[letterIndex].letter;
        final letterOccurrencesNumber = letter.allMatches(_wordToGuess).length;
        final correctLetterOccurrencesNumber = _currentWordTiles
            .where((element) =>
                element.letter == letter &&
                element.letterStatus == LetterStatus.correct)
            .length;
        final presentLetterOccurrencesNumber = board
            .sublist(_boardRowIndex * _wordToGuessLength, letterIndex)
            .where((element) =>
                element.letter == letter &&
                element.letterStatus == LetterStatus.present)
            .length;

        board[letterIndex] = TileData(
            letter: letter,
            letterStatus: _wordToGuess.contains(letter) &&
                    correctLetterOccurrencesNumber +
                            presentLetterOccurrencesNumber +
                            1 <=
                        letterOccurrencesNumber
                ? LetterStatus.present
                : LetterStatus.absent);

        _setKeyboardLetterStatus(letter, board[letterIndex].letterStatus);
      }
    }
  }

  void _updateBoardAndKeyboardAgainstPreviousAttempts(List<String> attempts) {
    for (var attempt in attempts) {
      for (var i = 0; i < attempt.length; i++) {
        pushLetter(attempt[i]);
      }

      _updateBoardAndKeyboardAgainstCurrentAttempt();

      _boardColumnIndex = 0;
      _boardRowIndex++;
    }
  }
}
