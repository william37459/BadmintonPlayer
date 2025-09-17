import 'package:app/global/constants.dart';
import 'package:app/team_tournament_results/all_league_matches/index.dart';
import 'package:app/team_tournament_results/club_result/classes/team_tournament_club_result.dart';
import 'package:app/team_tournament_results/club_result/functions/get_club_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<int> selectedLeague = StateProvider<int>((ref) => 0);

FutureProvider<List<TeamTournamentClubResult>> seasonPlanFutureProvider =
    FutureProvider<List<TeamTournamentClubResult>>((ref) async {
      int league = ref.watch(selectedLeague);
      final result = await getClubResults(league);
      return result;
    });

final PageController pageController = PageController(initialPage: 1);

class TeamTournamentClubResultWidget extends ConsumerWidget {
  final String header;
  const TeamTournamentClubResultWidget({super.key, required this.header});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureAsyncValue = ref.watch(seasonPlanFutureProvider);
    final colorThemeState = ref.watch(colorThemeProvider);
    return Scaffold(
      backgroundColor: colorThemeState.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: colorThemeState.fontColor.withValues(alpha: 0.5),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      header,
                      style: TextStyle(
                        color: colorThemeState.fontColor.withValues(alpha: 0.8),
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
                ],
              ),
            ),
            futureAsyncValue.when(
              data: (data) => Expanded(
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colorThemeState.fontColor.withValues(alpha: 0.1),
                    ),
                  ),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      ref.read(selectedLeagueGroup.notifier).state =
                          data[index].leagueGroupId;
                      ref.read(selectedLeagueTeam.notifier).state =
                          data[index].leagueTeamId;

                      Navigator.of(context).pushNamed(
                        "/TeamTournamentLeagueMatches",
                        arguments: {"header": data[index].clubName},
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16,
                      ),
                      child: Row(
                        spacing: 16,
                        children: [
                          Text(
                            "${data[index].placement}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colorThemeState.primaryColor,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].clubName,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                DefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorThemeState.fontColor.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Column(
                                      children: [
                                        Row(
                                          spacing: 16,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Vundet ${data[index].won} af ${data[index].matches} kampe",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                data[index].points != -1
                                                    ? "Point: ${data[index].points}"
                                                    : "",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                data[index].sPoints != -1
                                                    ? "S.Point: ${data[index].sPoints}"
                                                    : "",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Score: ${data[index].score}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: colorThemeState
                                                      .fontColor
                                                      .withValues(alpha: 0.7),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Sæt: ${data[index].sets}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const Expanded(
                                              child: Text(
                                                "",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: colorThemeState.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              error: (error, stacktrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(error.toString(), textAlign: TextAlign.center),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
