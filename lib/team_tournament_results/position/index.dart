import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/classes/team_tournament_position.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament_results/position/functions/get_team_tournament_positions.dart';
import 'package:app/team_tournament_results/position/widgets/team_position_widget.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FutureProvider<TeamTournamentPosition> teamTournaments =
    FutureProvider<TeamTournamentPosition>((ref) async {
  final filters = ref.watch(teamTournamentSearchFilterProvider);
  final result = await getTeamTournamentPositions(contextKey, filters.toJson());
  return result;
});

class TeamTournamentPositionWidget extends ConsumerWidget {
  final String title;
  const TeamTournamentPositionWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureAsyncValue = ref.watch(teamTournaments);
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Scaffold(
      body: SafeArea(
        child: futureAsyncValue.when(
          data: (data) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          teamTournamentSearchFilterStack.removeLast();
                          Navigator.pop(context);
                          ref
                              .read(teamTournamentSearchFilterProvider.notifier)
                              .state = teamTournamentSearchFilterStack.last;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorThemeState.secondaryColor,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: colorThemeState.secondaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12),
                          child: Text(
                            title,
                            style: TextStyle(
                              color: colorThemeState.secondaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                for (TeamTournamentFilter button in data.buttons)
                  CustomContainer(
                    onTap: () {
                      ref
                          .read(teamTournamentSearchFilterProvider.notifier)
                          .state = button;
                      teamTournamentSearchFilterStack.add(button);

                      if (button.subPage == "4") {
                        Navigator.pushNamed(
                          context,
                          "/AllTeamTournamentMatchesPage",
                        );
                      } else if (button.subPage == "0") {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/MainBuilder",
                          ModalRoute.withName('/MainBuilder'),
                        );
                      } else if (button.subPage == "1") {
                        Navigator.of(context)
                            .pushNamed("/TeamTournamentRegionPage", arguments: {
                          "region": "Holdturnering",
                          "rank": "",
                        });
                      }
                    },
                    child: Text(
                      button.text,
                      style: TextStyle(
                        color: colorThemeState.fontColor.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Text(
                    "Resultater",
                    style: TextStyle(
                      color: colorThemeState.secondaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                for (TeamTournamentPositionTeam team in data.teams)
                  TeamPositionWidget(
                    team: team,
                  )
              ],
            ),
          ),
          loading: () => Center(
            child: CircularProgressIndicator(
              color: colorThemeState.secondaryColor,
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "Der skete en fejl",
              style: TextStyle(
                color: colorThemeState.secondaryColor,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
