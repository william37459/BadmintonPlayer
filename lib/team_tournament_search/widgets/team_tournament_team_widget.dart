import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
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

    return CustomContainer(
      padding: const EdgeInsets.all(0),
      child: InkWell(
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
            final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
            await asyncPrefs.setStringList(
              'favouriteTeams',
              ref.read(favouriteTeams.notifier).state ?? [],
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Stack(
                children: [
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    firstChild: Icon(
                      Icons.star,
                      color: colorThemeState.primaryColor.withOpacity(0.8),
                      size: 32,
                    ),
                    secondChild: Icon(
                      Icons.star_outline,
                      color: colorThemeState.fontColor.withOpacity(0.3),
                      size: 32,
                    ),
                    crossFadeState: favouriteTeamsState.contains(
                      result.allValues,
                    )
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorThemeState.fontColor,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Opacity(
                      opacity: 0.4,
                      child: Text(
                        result.club,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colorThemeState.fontColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
