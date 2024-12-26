import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/tournament_result_page/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultLabel extends ConsumerWidget {
  final String label;
  final int index;
  const ResultLabel({super.key, required this.label, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    bool isSelected =
        ref.read(tournamentResultFilterProvider)["tournamenteventid"] == index;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isSelected ? 1 : 0.5,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              ref.read(tournamentResultFilterProvider.notifier).state = {
                ...ref.read(tournamentResultFilterProvider.notifier).state,
                "tournamenteventid": index,
              };
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorThemeState.secondaryFontColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: colorThemeState.fontColor,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
