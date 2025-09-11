import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/classes/team_tournament_result.dart';
import 'package:app/global/classes/tournament_result.dart';
import 'package:app/global/constants.dart';
import 'package:app/player_profile/widgets/ranks_widget.dart';
import 'package:app/team_tournament_results/match_result/functions/get_match_result.dart';
import 'package:app/team_tournament_results/match_result/widgets/tournament_info_bottom_sheet.dart';
import 'package:app/tournament_result_page/widgets/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<String> leagueMatchIDProvider = StateProvider<String>(
  (ref) => "",
);

FutureProvider<TeamTournamentResult> teamTournaments =
    FutureProvider<TeamTournamentResult>((ref) async {
      String leagueMatchID = ref.watch(leagueMatchIDProvider);
      TeamTournamentResult result = await getTeamTournamentMatchResult(
        contextKey,
        leagueMatchID,
      );
      return result;
    });

class TeamTournamentMatchResultWidget extends ConsumerWidget {
  const TeamTournamentMatchResultWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureAsyncValue = ref.watch(teamTournaments);
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    String leagueMatchID = ref.watch(leagueMatchIDProvider);

    return futureAsyncValue.when(
      data: (data) => Scaffold(
        appBar: AppBar(
          backgroundColor: colorThemeState.primaryColor,
          title: Text(
            "Resultat for #$leagueMatchID",
            style: TextStyle(
              fontSize: 18,
              color: colorThemeState.secondaryFontColor,
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.chevron_left, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: colorThemeState.backgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (BuildContext context) =>
                      TournamentInfoBottomSheet(entries: data.info.entries),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: colorThemeState.backgroundColor,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16,
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    RankTextWidget(
                      headerStyle: TextStyle(
                        fontSize: 16,
                        color: colorThemeState.secondaryFontColor,
                      ),
                      footers: const ["Point", "Vundne"],
                      score: ScoreData(
                        type: data.homeTeam,
                        rank: "",
                        points: data.points.split("-")[0],
                        matches: "",
                        placement: data.result.split("-")[0],
                      ),
                      colorThemeState: colorThemeState,
                    ),
                    const Text(
                      "VS",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    RankTextWidget(
                      headerStyle: TextStyle(
                        fontSize: 16,
                        color: colorThemeState.secondaryFontColor,
                      ),
                      footers: const ["Point", "Vundne"],
                      score: ScoreData(
                        type: data.awayTeam,
                        rank: "",
                        points: data.points.split("-")[1],
                        matches: "",
                        placement: data.result.split("-")[1],
                      ),
                      colorThemeState: colorThemeState,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (TournamentResult result in data.matches)
                        ResultWidget(
                          result: result.matches[0],
                          pool: result.resultName,
                          showInfo: false,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }
}
