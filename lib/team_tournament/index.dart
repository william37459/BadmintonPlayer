import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament/functions/get_setup_team_tournaments.dart';
import 'package:app/calendar/widgets/custom_autofill_input.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/calendar/widgets/custom_input.dart';
import 'package:app/calendar/widgets/drop_down_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Map<String, dynamic>> teamTournamentFilterProvider =
    StateProvider<Map<String, dynamic>>((ref) {
  return {
    "region": null,
    "year": null,
    "club": null,
    "matchNumber": null,
    "season": "2023",
  };
});

FutureProvider<List<Map<String, String>>> seasonPlanFutureProvider =
    FutureProvider<List<Map<String, String>>>((ref) async {
  final result = await getSetupTeamTournaments();
  return result;
});

class TeamTournamentPage extends ConsumerWidget {
  const TeamTournamentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    final Map<String, dynamic> filterProviderState =
        ref.watch(teamTournamentFilterProvider);

    final futureAsyncValue = ref.watch(seasonPlanFutureProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Holdturnering",
              style: TextStyle(
                color: colorThemeState.secondaryColor,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: futureAsyncValue.when(
              data: (data) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Sæson:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: colorThemeState.secondaryColor
                                  .withValues(alpha: 0.75),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomDropDownSelector(
                            data: data[2],
                            provider: teamTournamentFilterProvider,
                            providerKey: "season",
                            hint: "Vælg sæson",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Badminton Danmark / Kreds",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CustomContainer(
                      child: CustomDropDownSelector(
                        hint: "Vælg kreds",
                        provider: teamTournamentFilterProvider,
                        providerKey: "region",
                        data: data[0],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Årgang",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CustomContainer(
                      child: CustomDropDownSelector(
                        hint: "Vælg årgang",
                        provider: teamTournamentFilterProvider,
                        providerKey: "year",
                        data: data[1],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedOpacity(
                        opacity: (filterProviderState['year'] != null &&
                                    filterProviderState['year'].isNotEmpty) &&
                                (filterProviderState['region'] != null &&
                                    filterProviderState['region'].isNotEmpty)
                            ? 1
                            : 0.3,
                        duration: const Duration(
                          milliseconds: 250,
                        ),
                        child: Material(
                          color: colorThemeState.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: (filterProviderState['year'] != null &&
                                        filterProviderState['year']
                                            .isNotEmpty) &&
                                    (filterProviderState['region'] != null &&
                                        filterProviderState['region']
                                            .isNotEmpty)
                                ? () {
                                    ref
                                        .read(teamTournamentSearchFilterProvider
                                            .notifier)
                                        .state = TeamTournamentFilter(
                                      text: "",
                                      clubID: "",
                                      leagueGroupID: "",
                                      leagueGroupTeamID: "",
                                      leagueMatchID: "",
                                      ageGroupID: filterProviderState['year'],
                                      playerID: "",
                                      regionID: filterProviderState['region'],
                                      seasonID: "2023",
                                      subPage: "1",
                                    );
                                    teamTournamentSearchFilterStack.add(
                                      TeamTournamentFilter(
                                        text: "",
                                        clubID: "",
                                        leagueGroupID: "",
                                        leagueGroupTeamID: "",
                                        leagueMatchID: "",
                                        ageGroupID: filterProviderState['year'],
                                        playerID: "",
                                        regionID: filterProviderState['region'],
                                        seasonID: "2023",
                                        subPage: "1",
                                      ),
                                    );
                                    Navigator.of(context).pushNamed(
                                      '/TeamTournamentRegionPage',
                                      arguments: {
                                        "region": data[0]
                                            [filterProviderState['region']],
                                        "rank": data[1]
                                            [filterProviderState['year']],
                                      },
                                    );
                                  }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Søg",
                                style: TextStyle(
                                  color: colorThemeState.secondaryFontColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: colorThemeState.primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Eller",
                            style: TextStyle(
                              color: colorThemeState.primaryColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: colorThemeState.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Klub",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        CustomContainer(
                          child: CustomAutoFill(
                            hint: "Søg efter klub",
                            provider: teamTournamentFilterProvider,
                            providerKey: "club",
                            converter: {
                              for (var element in clubs)
                                element.fullClubName: element.clubId.toString(),
                            },
                            suggestions:
                                clubs.map((e) => e.fullClubName).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedOpacity(
                            opacity: filterProviderState['club'] != null &&
                                    filterProviderState['club'].isNotEmpty
                                ? 1
                                : 0.3,
                            duration: const Duration(
                              milliseconds: 250,
                            ),
                            child: Material(
                              color: colorThemeState.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: filterProviderState['club'] != null &&
                                        filterProviderState['club'].isNotEmpty
                                    ? () {
                                        ref
                                            .read(
                                                teamTournamentSearchFilterProvider
                                                    .notifier)
                                            .state = TeamTournamentFilter(
                                          text: "",
                                          clubID: filterProviderState['club'],
                                          leagueGroupID: "",
                                          leagueGroupTeamID: "",
                                          leagueMatchID: "",
                                          ageGroupID: "",
                                          playerID: "",
                                          regionID: "",
                                          seasonID: "2023",
                                          subPage: "6",
                                        );
                                        teamTournamentSearchFilterStack.add(
                                          TeamTournamentFilter(
                                            text: "",
                                            clubID: filterProviderState['club'],
                                            leagueGroupID: "",
                                            leagueGroupTeamID: "",
                                            leagueMatchID: "",
                                            ageGroupID: "",
                                            playerID: "",
                                            regionID: "",
                                            seasonID: "2023",
                                            subPage: "6",
                                          ),
                                        );
                                        Navigator.of(context).pushNamed(
                                          '/TeamTournamentClubPage',
                                          arguments: {
                                            "club": "", //TODO FIKS
                                          },
                                        );
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Søg",
                                    style: TextStyle(
                                      color: colorThemeState.secondaryFontColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: colorThemeState.primaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Eller",
                            style: TextStyle(
                              color: colorThemeState.primaryColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: colorThemeState.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Kampnummer",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        CustomContainer(
                          child: CustomInput(
                            hint: "Søg efter kampnummer",
                            provider: teamTournamentFilterProvider,
                            providerKey: "matchNumber",
                            inputType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedOpacity(
                            opacity:
                                filterProviderState['matchNumber'] != null &&
                                        filterProviderState['matchNumber']
                                            .isNotEmpty
                                    ? 1
                                    : 0.3,
                            duration: const Duration(
                              milliseconds: 250,
                            ),
                            child: Material(
                              color: colorThemeState.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: filterProviderState['matchNumber'] !=
                                            null &&
                                        filterProviderState['matchNumber']
                                            .isNotEmpty
                                    ? () {
                                        ref
                                            .read(
                                                teamTournamentSearchFilterProvider
                                                    .notifier)
                                            .state = TeamTournamentFilter(
                                          text: "",
                                          clubID: "",
                                          leagueGroupID: "",
                                          leagueGroupTeamID: "",
                                          leagueMatchID: filterProviderState[
                                              'matchNumber'],
                                          ageGroupID: "",
                                          playerID: "",
                                          regionID: "",
                                          seasonID: "2023",
                                          subPage: "5",
                                        );
                                        teamTournamentSearchFilterStack.add(
                                          TeamTournamentFilter(
                                            text: "",
                                            clubID: "",
                                            leagueGroupID: "",
                                            leagueGroupTeamID: "",
                                            leagueMatchID: filterProviderState[
                                                'matchNumber'],
                                            ageGroupID: "",
                                            playerID: "",
                                            regionID: "",
                                            seasonID: "2023",
                                            subPage: "5",
                                          ),
                                        );
                                        Navigator.of(context).pushNamed(
                                          '/TeamTournamentMatchResultPage',
                                          arguments: {
                                            "matchNumber": filterProviderState[
                                                'matchNumber'],
                                          },
                                        );
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Søg",
                                    style: TextStyle(
                                      color: colorThemeState.secondaryFontColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text(
                  "Der skete en fejl",
                  style: TextStyle(
                    color: colorThemeState.secondaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
