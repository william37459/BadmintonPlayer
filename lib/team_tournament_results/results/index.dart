import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_club_result.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament_results/all_matches/widgets/match_result_widget.dart';
import 'package:app/team_tournament_results/results/functions/get_team_tournament_results.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FutureProvider<TeamTournamentResults> teamTournaments =
    FutureProvider<TeamTournamentResults>((ref) async {
  final filters = ref.watch(teamTournamentSearchFilterProvider);
  final result = await getTeamTournamentResults(contextKey, filters.toJson());
  return result;
});

class TeamTournamentClubResultsWidget extends ConsumerWidget {
  const TeamTournamentClubResultsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureAsyncValue = ref.watch(teamTournaments);
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return futureAsyncValue.when(
      data: (data) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
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
                            "Resultater",
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
                for (TeamTournamentResultTeam team in data.teams)
                  MatchResultWidget(
                    result: team,
                  ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }
}
