import 'package:app/global/constants.dart';
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
    return Material(
      color: colorThemeState.backgroundColor,
      child: SafeArea(
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
                    child: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        header,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.8,
                          ),
                          fontSize: 16,
                        ),
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
                  separatorBuilder: (context, index) =>
                      index + 1 == (data.length / 2).ceil()
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: colorThemeState.fontColor,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_downward,
                              size: 12,
                              color: colorThemeState.fontColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: Text(
                                "Nedrykning",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorThemeState.fontColor,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_downward,
                              size: 12,
                              color: colorThemeState.fontColor,
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: colorThemeState.fontColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: colorThemeState.fontColor.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed("/TeamTournamentLeagueMatches"),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: Row(
                        spacing: 16,
                        children: [
                          Text(
                            "${data[index].placement}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorThemeState.primaryColor,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].clubName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Vundet ${data[index].won} af ${data[index].matches} kampe",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Opacity(
                                  opacity: 0.8,
                                  child: Wrap(
                                    spacing: 16,
                                    children: [
                                      Text(
                                        "Score: ${data[index].score}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Sæt: ${data[index].sets}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      if (data[index].points != -1)
                                        Text(
                                          "Point: ${data[index].points}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      if (data[index].sPoints != -1)
                                        Text(
                                          "S.Point: ${data[index].sPoints}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                    ],
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
