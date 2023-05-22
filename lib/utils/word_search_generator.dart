import 'dart:math';

class WordSearchGenerator {
  List<String> generateWordSearch(List<String> words, int gridSize) {
    List<List<String>> grid = _createEmptyGrid(gridSize);

    // Place words in the grid
    for (String word in words) {
      bool wordPlaced = false;

      while (!wordPlaced) {
        // Select random starting position and direction
        int row = Random().nextInt(gridSize);
        int col = Random().nextInt(gridSize);
        int direction =
            Random().nextInt(8); // 8 directions: N, NE, E, SE, S, SW, W, NW

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

    // Convert the grid to a list of strings
    List<String> puzzle = [];
    puzzle = grid.expand((element) => element).toList();

    return puzzle;
  }

  List<List<String>> _createEmptyGrid(int size) {
    return List<List<String>>.generate(
        size, (_) => List<String>.filled(size, ''));
  }

  bool _canPlaceWord(
      List<List<String>> grid, String word, int row, int col, int direction) {
    int len = word.length;
    int gridSize = grid.length;

    // Calculate the change in row and column for the given direction
    int dRow = (direction == 0 || direction == 1 || direction == 7)
        ? -1
        : (direction == 3 || direction == 4 || direction == 5)
            ? 1
            : 0;
    int dCol = (direction == 1 || direction == 2 || direction == 3)
        ? 1
        : (direction == 5 || direction == 6 || direction == 7)
            ? -1
            : 0;

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

      if (grid[currentRow][currentCol] != '') {
        if (grid[currentRow][currentCol] != word[i]) {
          return false;
        }
      }
    }

    return true;
  }

  void _placeWord(
      List<List<String>> grid, String word, int row, int col, int direction) {
    int len = word.length;

    // Calculate the change in row and column for the given direction
    int dRow = (direction == 0 || direction == 1 || direction == 7)
        ? -1
        : (direction == 3 || direction == 4 || direction == 5)
            ? 1
            : 0;
    int dCol = (direction == 1 || direction == 2 || direction == 3)
        ? 1
        : (direction == 5 || direction == 6 || direction == 7)
            ? -1
            : 0;

    for (int i = 0; i < len; i++) {
      int currentRow = row + i * dRow;
      int currentCol = col + i * dCol;

      grid[currentRow][currentCol] = word[i];
    }
  }

  void _fillEmptySpaces(List<List<String>> grid) {
    int gridSize = grid.length;

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (grid[row][col] == '') {
          // Generate random letter
          String randomLetter = String.fromCharCode(Random().nextInt(26) + 65);
          grid[row][col] = randomLetter;
        }
      }
    }
  }
}
