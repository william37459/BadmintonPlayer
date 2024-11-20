import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/classes/tournament_result.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultWidget extends ConsumerWidget {
  final MatchResult result;
  const ResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorThemeState.secondaryFontColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (Profile winner in result.winner)
                      Text(
                        textAlign: TextAlign.left,
                        winner.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorThemeState.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "-",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (Profile loser in result.loser)
                      Text(
                        loser.name,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorThemeState.primaryColor.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          for (String point in result.result)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: int.tryParse(point.split("/").first) ?? 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8),
                        ),
                        color: (int.tryParse(point.split("/").last.trim()) ??
                                    1) <
                                (int.tryParse(point.split("/").first.trim()) ??
                                    1)
                            ? colorThemeState.primaryColor
                            : colorThemeState.primaryColor.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          point.split("/").first,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: colorThemeState.secondaryFontColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: int.tryParse(point.split("/").last) ?? 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(8),
                        ),
                        color: (int.tryParse(point.split("/").first.trim()) ??
                                    1) <
                                (int.tryParse(point.split("/").last.trim()) ??
                                    1)
                            ? colorThemeState.primaryColor
                            : colorThemeState.primaryColor.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          point.split("/").last,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: colorThemeState.secondaryFontColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
