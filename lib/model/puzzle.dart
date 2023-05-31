import 'package:crossword_puzzle/model/grid_item.dart';

class Puzzle {
  Puzzle({
    this.grid,
    this.hightlightedWords = const [],
    this.words,
  });

  final List<List<GridItem>>? grid;
  List<String> hightlightedWords;
  final List<String>? words;
}
