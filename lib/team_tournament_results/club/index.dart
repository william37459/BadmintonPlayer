import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament_results/club/functions/get_tournament_club.dart';
import 'package:app/calendar/widgets/custom_container.dart';
import 'package:app/calendar/widgets/custom_expander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FutureProvider<Map<String, List<TeamTournamentFilterClub>>> teamTournaments =
    FutureProvider<Map<String, List<TeamTournamentFilterClub>>>((ref) async {
  final filters = ref.watch(teamTournamentSearchFilterProvider);
  final result = await getTeamTournamentClub(contextKey, filters.toJson());
  return result;
});

class TeamTournamentClubPage extends ConsumerWidget {
  final String club;
  const TeamTournamentClubPage({
    super.key,
    required this.club,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    final futureAsyncValue = ref.watch(teamTournaments);

    return Scaffold(
      body: SafeArea(
        child: futureAsyncValue.when(
          data: (data) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
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
                          club,
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (String header in data.keys)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CustomExpander(
                            header: Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  header,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: colorThemeState.secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                            isExpandedKey: header,
                            isExpanded: true,
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (TeamTournamentFilterClub filter
                                    in data[header] ?? [])
                                  CustomContainer(
                                    padding: const EdgeInsets.all(0),
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(4),
                                        onTap: () {
                                          ref
                                              .read(
                                                  teamTournamentSearchFilterProvider
                                                      .notifier)
                                              .state = TeamTournamentFilter(
                                            text: "",
                                            clubID: filter.clubID,
                                            leagueGroupID: filter.leagueGroupID,
                                            leagueGroupTeamID: "",
                                            leagueMatchID: "",
                                            ageGroupID: filter.ageGroupID,
                                            playerID: "",
                                            regionID: "",
                                            seasonID: "2023",
                                            subPage: "2",
                                          );
                                          teamTournamentSearchFilterStack.add(
                                            TeamTournamentFilter(
                                              text: "",
                                              clubID: filter.clubID,
                                              leagueGroupID:
                                                  filter.leagueGroupID,
                                              leagueGroupTeamID: "",
                                              leagueMatchID: "",
                                              ageGroupID: filter.ageGroupID,
                                              playerID: "",
                                              regionID: "",
                                              seasonID: filter.seasonID,
                                              subPage: "2",
                                            ),
                                          );
                                          Navigator.of(context).pushNamed(
                                            "/TeamTournamentPositionPage",
                                            arguments: {
                                              "title": filter.text,
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      filter.club,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: colorThemeState
                                                            .secondaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      filter.text,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: colorThemeState
                                                            .secondaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                Icons.chevron_right,
                                                color: colorThemeState
                                                    .secondaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          error: (error, stackTrace) => const Text("error"),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
