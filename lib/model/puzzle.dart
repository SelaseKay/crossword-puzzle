class Puzzle {
   Puzzle({
    this.grid,
    this.hightlightedWords =  const [],
    this.words,
  });

  final List<List<String>>? grid;
   List<String> hightlightedWords;
  final List<String>? words;
}
