import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/classes/tournament_result.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultWidget extends ConsumerWidget {
  final MatchResult result;
  final String pool;
  final bool showInfo;
  final bool showHeader;

  const ResultWidget({
    super.key,
    required this.result,
    required this.pool,
    this.showInfo = true,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: colorThemeState.secondaryFontColor,
        elevation: 1,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {},
          child: Column(
            spacing: 12,
            children: [
              if (showHeader)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pool,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (showInfo)
                        const Icon(
                          Icons.info_outlined,
                        ),
                    ],
                  ),
                ),
              if (!showHeader)
                const SizedBox(
                  height: 0,
                ),
              for (List<Profile> profiles in [result.winner, result.loser])
                Opacity(
                  opacity: [
                    1.0,
                    0.6
                  ][[result.winner, result.loser].indexOf(profiles)],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                profiles
                                    .map((player) => player.name)
                                    .join(", "),
                                softWrap: true,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                profiles
                                    .map((player) => player.club)
                                    .toSet()
                                    .join(", "),
                              ),
                            ],
                          ),
                        ),
                        for (String score in result.result)
                          Text(
                            score.split("/").length == 1
                                ? (score.isEmpty
                                            ? ["W.O", "-"]
                                            : score.split("-"))
                                        .elementAtOrNull([
                                      result.winner,
                                      result.loser
                                    ].indexOf(profiles)) ??
                                    "W.O"
                                : (score.isEmpty
                                            ? ["W.O", "-"]
                                            : score.split("/"))
                                        .elementAtOrNull([
                                      result.winner,
                                      result.loser
                                    ].indexOf(profiles)) ??
                                    "W.O",
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
