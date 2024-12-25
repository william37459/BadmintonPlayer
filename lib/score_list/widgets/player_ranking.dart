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
        Navigator.pushNamed(
          context,
          '/PlayerProfilePage',
          arguments: {
            'name': playerScore.name,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              playerScore.rank,
              style: TextStyle(
                color: colorThemeState.fontColor.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playerScore.name,
                    style: TextStyle(
                      color:
                          colorThemeState.primaryColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "${playerScore.rankClass}${playerScore.rankClass.isNotEmpty && playerScore.points != null ? ', ' : ''}${playerScore.points == null ? '' : '${playerScore.points} point'}",
                    style: TextStyle(
                      color: colorThemeState.fontColor.withValues(alpha: 0.5),
                      fontSize: 14,
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
                  Icons.info_outline,
                  color: colorThemeState.primaryColor,
                ),
              ],
            ),
            // Text(playerScore.rankClass),
          ],
        ),
      ),
    );
  }
}
