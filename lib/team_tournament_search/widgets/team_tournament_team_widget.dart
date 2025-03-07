import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamTournamentTeamWidget extends ConsumerWidget {
  final TeamTournamentFilterClub result;

  const TeamTournamentTeamWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    List<String> favouriteTeamsState = ref.watch(favouriteTeams) ?? [];

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () async {
            if (favouriteTeamsState.contains(result.allValues)) {
              ref.read(favouriteTeams.notifier).state = [
                ...favouriteTeamsState.where(
                  (element) => element != result.allValues,
                ),
              ];
            } else {
              ref.read(favouriteTeams.notifier).state = [
                ...favouriteTeamsState,
                result.allValues,
              ];
              final SharedPreferencesAsync asyncPrefs =
                  SharedPreferencesAsync();
              await asyncPrefs.setStringList(
                'favouriteTeams',
                ref.read(favouriteTeams.notifier).state ?? [],
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  firstChild: Icon(
                    Icons.star_rounded,
                    color: colorThemeState.primaryColor.withValues(alpha: 0.8),
                    size: 32,
                  ),
                  secondChild: Icon(
                    Icons.star_outline_rounded,
                    color: colorThemeState.fontColor.withValues(alpha: 0.3),
                    size: 32,
                  ),
                  crossFadeState: favouriteTeamsState.contains(
                    result.allValues,
                  )
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: colorThemeState.fontColor,
                        ),
                      ),
                      Text(
                        result.club,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              colorThemeState.fontColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    );
  }
}
