import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_score.dart';
import 'package:app/global/constants.dart';
// import 'package:app/score_list/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerRanking extends ConsumerWidget {
  final PlayerScore playerScore;
  const PlayerRanking({
    super.key,
    required this.playerScore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    // final List<String> likedIdsState = ref.watch(likedIds);

    return InkWell(
      onTap: () {
        ref.read(selectedPlayer.notifier).state = playerScore.id;
        // Navigator.pushNamed(
        //   context,
        //   '/PlayerProfilePage',
        //   arguments: {
        //     'name': playerScore.name,
        //   },
        // );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Text(
                  playerScore.rank,
                  style: TextStyle(
                    color: colorThemeState.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerScore.name,
                        style: TextStyle(
                          color: colorThemeState.fontColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${playerScore.rankClass}${playerScore.rankClass.isNotEmpty && playerScore.points != null ? ', ' : ''}${playerScore.points == null ? '' : '${playerScore.points} point'}",
                        style: TextStyle(
                          color:
                              colorThemeState.fontColor.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.chevron_right,
                      color: colorThemeState.fontColor.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                // Text(playerScore.rankClass),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: colorThemeState.fontColor.withValues(alpha: 0.5),
              borderRadius: BorderRadiusDirectional.circular(2),
            ),
            height: 0.25,
          )
        ],
      ),
    );
  }
}
