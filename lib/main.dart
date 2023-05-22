import 'package:confetti/confetti.dart';
import 'package:crossword_puzzle/componenets/words_container.dart';
import 'package:crossword_puzzle/provider/letter_position_provider.dart';
import 'package:crossword_puzzle/provider/puzzle_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'confetti_animation/draw_path.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Crossword Puzzle'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  GlobalKey gridKey = GlobalKey();
  late ConfettiController _controllerCenter;

  List<List<String>> gridState = [
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
  ];

  int _startIndexX = 0;
  int _startIndexY = 0;

  String _highlightedWord = "";

  List<int> repeatedLetterIdx = [];

  List<int> _getIndexs(details, gridItemKey) {
    RenderBox box = gridItemKey.currentContext?.findRenderObject() as RenderBox;
    RenderBox boxGrid = gridKey.currentContext?.findRenderObject() as RenderBox;
    Offset position =
        boxGrid.localToGlobal(Offset.zero); //this is global position
    double gridLeft = position.dx;
    double gridTop = position.dy;

    double gridPosition = details.globalPosition.dy - gridTop;

    //Get item position
    int indexX = (gridPosition / box.size.width).floor().toInt();
    int indexY = ((details.globalPosition.dx - gridLeft) / box.size.width)
        .floor()
        .toInt();
    return [indexX, indexY];
  }

  void onDragUpdate(details, gridItemKey, puzzle) {
    final indexes = _getIndexs(details, gridItemKey);
    final indexX = indexes[0];
    final indexY = indexes[1];

    if (_startIndexX == indexX || _startIndexY == indexY) {
      if (gridState[indexX][indexY] == "Y") {
        gridState[indexX][indexY] = "";
      } else {
        gridState[indexX][indexY] = "Y";
      }
      if (!listEquals(repeatedLetterIdx, indexes)) {
        _highlightedWord = _highlightedWord + puzzle[indexX][indexY];
        ref
            .read(letterPositionProvider.notifier)
            .setHighlightedPositions(indexX, indexY);
        print("Hightlighted word is: ${_highlightedWord}");
        repeatedLetterIdx = indexes;
      }

      selectItem(gridItemKey, details, gridState);
    }
  }

  onDragEnd(puzzleState, x, y) {
    if (!puzzleState.words!.contains(_highlightedWord)) {
      _highlightedWord = "";
      resetPuzzleTile();
    } else {
      ref.read(puzzleProvider.notifier).addHighlightedWord(_highlightedWord);
      _highlightedWord = "";
      ref.read(letterPositionProvider.notifier).clearHighlightedPositions();
      gridState[x][y] = "Y";
    }
  }

  resetPuzzleTile() {
    final letterPositions = ref.read(letterPositionProvider);
    if (letterPositions != null) {
      for (var letterPosition in letterPositions) {
        gridState[letterPosition.x][letterPosition.y] = "";
      }
    }
    setState(() {});
  }

  resetGrid() {
    gridState = [
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
    ];
    setState(() {});
  }

  void onDragStart(details, gridItemKey) {
    final indexes = _getIndexs(details, gridItemKey);
    _startIndexX = indexes[0];
    _startIndexY = indexes[1];
  }

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(puzzleProvider.notifier).generateWordSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final puzzleState = ref.watch(puzzleProvider);

    final highlightedWords = puzzleState.hightlightedWords;
    final words = puzzleState.words;

    ref.listen(puzzleProvider, (oldState, newState) {
      final hightlightedWordsLen = newState.hightlightedWords.length;
      final wordsLen = newState.words?.length;
      if (wordsLen == hightlightedWordsLen) {
        print("Show animation.......");
        _controllerCenter.play();
      }
    });

    ref.listen(letterPositionProvider, (oldState, newState) {});

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: puzzleState.grid == null
          ? const SizedBox.shrink()
          : Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Stack(
                    children: [
                      GridView.count(
                        key: gridKey,
                        crossAxisCount: 10,
                        padding: const EdgeInsets.all(8.0),
                        // crossAxisSpacing: 4.0,
                        // mainAxisSpacing: 8.0,
                        children: List.generate(100, (index) {
                          int gridStateLength = gridState.length;

                          int x, y = 0;
                          x = (index / gridStateLength).floor();
                          y = (index % gridStateLength);

                          GlobalKey gridItemKey = GlobalKey();
                          return GestureDetector(
                            onHorizontalDragStart: (details) {
                              onDragStart(details, gridItemKey);
                            },
                            onVerticalDragStart: (details) {
                              onDragStart(details, gridItemKey);
                            },
                            onHorizontalDragUpdate: (details) {
                              onDragUpdate(
                                  details, gridItemKey, puzzleState.grid);
                            },
                            onVerticalDragUpdate: (details) {
                              onDragUpdate(
                                  details, gridItemKey, puzzleState.grid);
                            },
                            onHorizontalDragEnd: (details) {
                              onDragEnd(puzzleState, x, y);
                            },
                            onVerticalDragEnd: (details) {
                              onDragEnd(puzzleState, x, y);
                            },
                            child: Container(
                              key: gridItemKey,
                              decoration: BoxDecoration(
                                color: gridState[x][y] == ""
                                    ? Colors.amber
                                    : Colors.blue,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.white, //New
                                      blurRadius: 25.0,
                                      offset: Offset(0, -10))
                                ],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Center(
                                child: puzzleState.grid != null
                                    ? Text(
                                        puzzleState.grid!
                                            .expand((element) => element)
                                            .toList()[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          );
                        }),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ConfettiWidget(
                          confettiController: _controllerCenter,
                          blastDirectionality: BlastDirectionality
                              .explosive, // don't specify a direction, blast randomly
                          shouldLoop:
                              true, // start again as soon as the animation is finished
                          colors: const [
                            Colors.green,
                            Colors.blue,
                            Colors.pink,
                            Colors.orange,
                            Colors.purple
                          ], // manually specify the colors to be used
                          createParticlePath:
                              drawStar, // define a custom shape/path.
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                const Flexible(
                  flex: 1,
                  child: WordsContainer(),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                highlightedWords.length == words?.length
                    ? ElevatedButton(
                        onPressed: () {
                          _controllerCenter.stop();
                          ref
                              .read(puzzleProvider.notifier)
                              .generateWordSearch();
                          ref
                              .read(letterPositionProvider.notifier)
                              .clearHighlightedPositions();
                          resetGrid();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("New Game"),
                      )
                    : const SizedBox.shrink()
              ],
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void selectItem(GlobalKey<State<StatefulWidget>> gridItemKey, var details,
      List<List<String>> puzzle) {
    RenderBox boxItem =
        gridItemKey.currentContext?.findRenderObject() as RenderBox;
    RenderBox boxMainGrid =
        gridKey.currentContext?.findRenderObject() as RenderBox;
    Offset position =
        boxMainGrid.localToGlobal(Offset.zero); //this is global position
    double gridLeft = position.dx;
    double gridTop = position.dy;

    double gridPosition = details.globalPosition.dy - gridTop;

    //Get item position
    int rowIndex = (gridPosition / boxItem.size.width).floor().toInt();
    int colIndex = ((details.globalPosition.dx - gridLeft) / boxItem.size.width)
        .floor()
        .toInt();
    puzzle[rowIndex][colIndex] = "Y";

    setState(() {});
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }
}
