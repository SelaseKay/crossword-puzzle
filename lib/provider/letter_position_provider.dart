import 'package:crossword_puzzle/model/letter_position.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final letterPositionProvider =
    StateNotifierProvider<LetterPositionNotifier, List<LetterPosition>?>(
        (ref) => LetterPositionNotifier(ref));

class LetterPositionNotifier extends StateNotifier<List<LetterPosition>?> {
  LetterPositionNotifier(this.ref) : super(null);

  final Ref ref;

  void setHighlightedPositions(x, y) {
    if (state == null) {
      state = [LetterPosition(x, y)];
    } else {
      state = [...state!, LetterPosition(x, y)];
    }
  }

  void clearHighlightedPositions() {
    state = [];
  }
}
