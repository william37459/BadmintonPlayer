import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RanksWidget extends ConsumerWidget {
  final List<ScoreData> scores;

  const RanksWidget({super.key, required this.scores});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Column(
      spacing: 4,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            RankTextWidget(score: scores[0], colorThemeState: colorThemeState),
            RankTextWidget(score: scores[1], colorThemeState: colorThemeState),
          ],
        ),
        if (scores.length > 2)
          Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              RankTextWidget(
                score: scores[2],
                colorThemeState: colorThemeState,
              ),
              RankTextWidget(
                score: scores.length > 3 ? scores[3] : ScoreData.empty(),
                colorThemeState: colorThemeState,
              ),
            ],
          ),
      ],
    );
  }
}

class RankTextWidget extends StatelessWidget {
  final ScoreData score;
  final CustomColorTheme colorThemeState;
  final TextStyle? headerStyle;
  final List<String>? footers;

  const RankTextWidget({
    super.key,
    required this.score,
    required this.colorThemeState,
    this.headerStyle,
    this.footers,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: colorThemeState.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${score.rank}${score.type.isNotEmpty && score.rank.isNotEmpty ? ', ' : ''}${score.type.replaceAll("Rangliste ", "").replaceAll("Tilmeldingsniveau", "Samlet")}",
              overflow: TextOverflow.ellipsis,
              style:
                  headerStyle ??
                  TextStyle(
                    color: colorThemeState.secondaryFontColor.withValues(
                      alpha: 0.8,
                    ),
                    fontSize: 10,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        score.points.isEmpty ? "-" : score.points,
                        style: TextStyle(
                          color: colorThemeState.secondaryFontColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        footers?.elementAtOrNull(0) ?? "Point",
                        style: TextStyle(
                          color: colorThemeState.secondaryFontColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 48,
                  width: 1,
                  decoration: BoxDecoration(
                    color: colorThemeState.secondaryFontColor.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        score.placement.isEmpty ? "-" : score.placement,
                        style: TextStyle(
                          color: colorThemeState.secondaryFontColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        footers?.elementAtOrNull(1) ?? "Placering",
                        style: TextStyle(
                          color: colorThemeState.secondaryFontColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
