import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/puzzle_provider.dart';

class WordsContainer extends ConsumerWidget {
  const WordsContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.watch(puzzleProvider);
    return  Wrap(
      children: List.generate(
        puzzleState.words != null ? puzzleState.words!.length : 0,
        (index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: puzzleState.words != null
                ? Text(
                    puzzleState.words![index],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: puzzleState.hightlightedWords.contains(puzzleState.words![index]) ? Colors.blue : Colors.grey,
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
