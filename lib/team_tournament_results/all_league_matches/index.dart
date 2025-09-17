import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/dashboard/widgets/team_tournament_result_preview.dart';
import 'package:app/global/constants.dart';
import 'package:app/score_list/widgets/player_ranking.dart';
import 'package:app/team_tournament_results/all_league_matches/functions/get_all_league_matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<int> selectedLeagueGroup = StateProvider((ref) => 0);
StateProvider<int> selectedLeagueTeam = StateProvider((ref) => 0);

FutureProvider<List<TeamTournamentResultPreview>>
seasonPlanFutureProvider = FutureProvider<List<TeamTournamentResultPreview>>((
  ref,
) async {
  int leagueGroup = ref.watch(selectedLeagueGroup);
  int leagueTeam = ref.watch(selectedLeagueTeam);

  print(
    "Fetching all league matches for group $leagueGroup and team $leagueTeam",
  );

  final List<TeamTournamentResultPreview> result = await getAllLeagueMatches(
    leagueGroup,
    leagueTeam,
  );
  return result;
});

class TeamTournamentLeagueMatches extends ConsumerWidget {
  final String header;
  const TeamTournamentLeagueMatches({required this.header, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColorTheme = ref.watch(colorThemeProvider);
    final futureAsyncValue = ref.watch(seasonPlanFutureProvider);

    return Scaffold(
      backgroundColor: customColorTheme.backgroundColor,
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
                      color: customColorTheme.fontColor.withValues(alpha: 0.5),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      header,
                      style: TextStyle(
                        color: customColorTheme.fontColor.withValues(
                          alpha: 0.8,
                        ),
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
                ],
              ),
            ),
            Expanded(
              child: futureAsyncValue.when(
                data: (data) => ListView.builder(
                  itemBuilder: (context, index) =>
                      TeamTournamentResultPreviewWidget(
                        result: data[index],
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                  itemCount: data.length,
                ),
                error: (error, stacktrace) => Text(error.toString()),
                loading: () => Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Center(
                    child: CustomCircularProgressIndicator(
                      color: customColorTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
