import 'dart:math';

import 'package:crossword_puzzle/data/word_list.dart';
import 'package:crossword_puzzle/model/grid_item.dart';
import 'package:crossword_puzzle/model/puzzle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'letter_position_provider.dart';

final puzzleProvider =
    StateNotifierProvider<PuzzleNotifier, Puzzle>((ref) => PuzzleNotifier(ref));

class PuzzleNotifier extends StateNotifier<Puzzle> {
  PuzzleNotifier(this.ref) : super(Puzzle());

  final Ref ref;
  int _wordIndex = 0;

  int get _getWordIndex {
    return _wordIndex++ % 4;
  }

  void setGridState(row, col, value) {
    final grid = [...state.grid!];

    grid[row][col].isSelected = value;

    state = Puzzle(
        grid: state.grid,
        hightlightedWords: state.hightlightedWords,
        words: state.words);
  }

  void resetGridItemState() {
    final letterPositions = ref.read(letterPositionProvider);
    if (letterPositions != null) {
      final grid = [...state.grid!];
      for (var letterPosition in letterPositions) {
        grid[letterPosition.x][letterPosition.y].isSelected = false;
        state = Puzzle(
          grid: state.grid,
          hightlightedWords: state.hightlightedWords,
          words: state.words,
        );
      }
    }
  }

  void addHighlightedWord(String word) {
    final hightlightedWords = {...state.hightlightedWords, word};

    state = Puzzle(
        grid: state.grid,
        words: state.words,
        hightlightedWords: hightlightedWords.toList());
  }

  void clearHighlightedWords() {
    state = Puzzle(grid: state.grid, words: state.words, hightlightedWords: []);
  }

  void generateWordSearch({int gridSize = 10}) {
    List<List<GridItem>> grid = _createEmptyGrid(gridSize);

    final words = WordList.words[_getWordIndex];

    // Place words in the grid
    for (String word in words) {
      bool wordPlaced = false;

      while (!wordPlaced) {
        // Select random starting position and direction
        int row = Random().nextInt(gridSize);
        int col = Random().nextInt(gridSize);
        int direction = Random().nextInt(2); // 2 directions: N, E

        // Check if the word fits in the selected direction
        if (_canPlaceWord(grid, word, row, col, direction)) {
          // Place the word in the grid
          _placeWord(grid, word, row, col, direction);
          wordPlaced = true;
        }
      }
    }

    // Fill remaining spaces with random letters
    _fillEmptySpaces(grid);

    state = Puzzle(grid: grid, words: words);
    clearHighlightedWords();
  }

  List<List<GridItem>> _createEmptyGrid(int size) {
    return List<List<GridItem>>.generate(
        size,
        (_) => List.generate(
              size,
              (_) => GridItem(letter: ""),
            ));
  }

  bool _canPlaceWord(
      List<List<GridItem>> grid, String word, int row, int col, int direction) {
    int len = word.length;
    int gridSize = grid.length;

    // Calculate the change in row and column for the given direction
    int dRow = (direction == 0) ? -1 : 0;
    int dCol = (direction == 1) ? 1 : 0;

    // Check if word goes out of bounds
    if (row + (len - 1) * dRow < 0 ||
        row + (len - 1) * dRow >= gridSize ||
        col + (len - 1) * dCol < 0 ||
        col + (len - 1) * dCol >= gridSize) {
      return false;
    }

    // Check if word overlaps with existing letters
    for (int i = 0; i < len; i++) {
      int currentRow = row + i * dRow;
      int currentCol = col + i * dCol;

      if (grid[currentRow][currentCol].letter != "") {
        if (grid[currentRow][currentCol].letter != word[i]) {
          return false;
        }
      }
    }

    return true;
  }

  void _placeWord(
      List<List<GridItem>> grid, String word, int row, int col, int direction) {
    int len = word.length;

    // Calculate the change in row and column for the given direction
    int dRow = (direction == 0) ? -1 : 0;
    int dCol = (direction == 1) ? 1 : 0;

    for (int i = 0; i < len; i++) {
      int currentRow = row + i * dRow;
      int currentCol = col + i * dCol;

      grid[currentRow][currentCol].letter = word[i];
    }
  }

  void _fillEmptySpaces(List<List<GridItem>> grid) {
    int gridSize = grid.length;

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (grid[row][col].letter.isEmpty) {
          // Generate random letter
          String randomLetter = String.fromCharCode(Random().nextInt(26) + 65);
          grid[row][col].letter = randomLetter;
        }
      }
    }
  }
}
