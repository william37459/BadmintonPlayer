import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_position.dart';
import 'package:app/global/constants.dart';
import 'package:app/calendar/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InformationHero extends ConsumerWidget {
  final String tag;
  final TeamTournamentPositionTeam team;
  const InformationHero({
    super.key,
    required this.tag,
    required this.team,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return Center(
      child: Hero(
        tag: tag,
        child: CustomContainer(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    team.name,
                    style: TextStyle(
                      color: colorThemeState.primaryColor.withOpacity(0.9),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Point",
                  style: TextStyle(
                    color: colorThemeState.secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "${team.points}, point",
                  style: TextStyle(
                    color: colorThemeState.primaryColor.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Stilling",
                  style: TextStyle(
                    color: colorThemeState.secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "${team.wins} ud af ${team.matches} vundne kampe",
                  style: TextStyle(
                    color: colorThemeState.primaryColor.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Stilling",
                  style: TextStyle(
                    color: colorThemeState.secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "${team.wins} ud af ${team.matches}",
                  style: TextStyle(
                    color: colorThemeState.primaryColor.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Material(
                  color: colorThemeState.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ref
                          .read(teamTournamentSearchFilterProvider.notifier)
                          .state = team.filter;
                      teamTournamentSearchFilterStack.add(team.filter);
                      Navigator.of(context).pushNamed(
                        "/TeamTournamentResultPage",
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "Se alle resultater",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorThemeState.secondaryFontColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
