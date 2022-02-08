enum LetterStatus { none, absent, present, correct }

extension LetterStatusExtension on LetterStatus {
  int get id {
    switch (this) {
      case LetterStatus.none:
        return 1;
      case LetterStatus.absent:
        return 2;
      case LetterStatus.present:
        return 3;
      case LetterStatus.correct:
        return 4;
    }
  }
}
