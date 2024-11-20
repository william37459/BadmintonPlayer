import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_result.dart';
import 'package:app/global/constants.dart';
import 'package:app/calendar/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MathResultWidget extends ConsumerWidget {
  final TeamTournamentMatch matchResult;
  const MathResultWidget({super.key, required this.matchResult});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return CustomContainer(
      child: Row(
        children: [
          Text(
            matchResult.type,
            style: TextStyle(
              color: colorThemeState.fontColor.withOpacity(0.5),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (TeamTournamentTeam team in matchResult.teams)
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              team.players.map((e) => e.name).join(', '),
                              style: TextStyle(
                                fontSize: 14,
                                color: colorThemeState.primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          for (String point in team.points
                              .where((element) => element.isNotEmpty))
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: team.winner
                                    ? colorThemeState.primaryColor
                                        .withOpacity(0.3)
                                    : colorThemeState.fontColor
                                        .withOpacity(0.05),
                              ),
                              child: Center(
                                child: Text(
                                  point,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorThemeState.fontColor,
                                    fontWeight: team.winner
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                          height: matchResult.teams.indexOf(team) == 0 ? 8 : 0),
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
