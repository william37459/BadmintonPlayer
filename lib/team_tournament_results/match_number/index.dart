import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_result.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament_results/match_number/functions/get_team_tournament_match_result.dart';
import 'package:app/team_tournament_results/match_number/widgets/match_result_widget.dart';
import 'package:app/calendar/widgets/custom_expander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FutureProvider<TeamTournamentResult> teamTournaments =
    FutureProvider<TeamTournamentResult>((ref) async {
  final filters = ref.watch(teamTournamentSearchFilterProvider);
  final result =
      await getTeamTournamentMatchResult(contextKey, filters.toJson());
  return result;
});

class TeamTournamentResultWidget extends ConsumerWidget {
  final String matchNumber;
  const TeamTournamentResultWidget({
    super.key,
    required this.matchNumber,
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
                            "Kampnummer $matchNumber",
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
                CustomExpander(
                  isExpanded: true,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        for (String mapKey in data.info.keys)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                mapKey,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colorThemeState.primaryColor,
                                ),
                              ),
                              for (String value in data.info[mapKey] ?? [])
                                Text(value),
                            ],
                          ),
                      ],
                    ),
                  ),
                  header: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Kampinformation",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: colorThemeState.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  isExpandedKey: "matchInfo",
                ),
                for (TeamTournamentMatch matchResult in data.matches)
                  MathResultWidget(
                    matchResult: matchResult,
                  ),
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
