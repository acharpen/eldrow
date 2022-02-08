import 'package:eldrow/models/letter_status.dart';

class TileData {
  String letter;
  LetterStatus letterStatus;

  TileData({required this.letter, this.letterStatus = LetterStatus.none});
}
