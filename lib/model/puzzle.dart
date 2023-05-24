class Puzzle {
  Puzzle({
    this.grid,
    this.gridState = const [
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
    ],
    this.hightlightedWords = const [],
    this.words,
  });

  final List<List<String>>? grid;
  final List<List<String>> gridState;
  List<String> hightlightedWords;
  final List<String>? words;
}
