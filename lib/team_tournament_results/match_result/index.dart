import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/classes/tournament_result.dart';
import 'package:app/global/constants.dart';
import 'package:app/player_profile/widgets/ranks_widget.dart';
import 'package:app/team_tournament_results/match_result/functions/get_match_result.dart';
import 'package:app/tournament_result_page/widgets/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<String> leagueMatchIDProvider =
    StateProvider<String>((ref) => "");

FutureProvider<List<TournamentResult>> teamTournaments =
    FutureProvider<List<TournamentResult>>((ref) async {
  String leagueMatchID = ref.watch(leagueMatchIDProvider);
  List<TournamentResult> result =
      await getTeamTournamentMatchResult(contextKey, leagueMatchID);
  return result;
});

class TeamTournamentClubResultsWidget extends ConsumerWidget {
  const TeamTournamentClubResultsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureAsyncValue = ref.watch(teamTournaments);
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    String leagueMatchID = ref.watch(leagueMatchIDProvider);

    return futureAsyncValue.when(
      data: (data) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Text(
                        "Resultat for #$leagueMatchID",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => print("Info"),
                      child: Icon(
                        Icons.info_outline,
                        color: colorThemeState.primaryColor,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    spacing: 12,
                    children: [
                      RankTextWidget(
                        headerStyle: TextStyle(
                          fontSize: 16,
                          color: colorThemeState.secondaryFontColor,
                        ),
                        footers: const [
                          "Point",
                          "Vundne",
                        ],
                        score: ScoreData(
                          type: "Vejgaard 1",
                          rank: "",
                          points: "9",
                          matches: "",
                          placement: "7",
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
                        footers: const [
                          "Point",
                          "Vundne",
                        ],
                        score: ScoreData(
                          type: "Skødstrup",
                          rank: "",
                          points: "9",
                          matches: "",
                          placement: "7",
                        ),
                        colorThemeState: colorThemeState,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 12,
                      children: [
                        for (TournamentResult result in data)
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
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }
}
