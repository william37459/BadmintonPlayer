import 'package:app/calendar/widgets/custom_autofill_input.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_club.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament/functions/get_by_club.dart';
import 'package:app/team_tournament/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FutureProvider<List<TeamTournamentClub>> clubProvider =
    FutureProvider<List<TeamTournamentClub>>((ref) async {
  final filterProviderState = ref.watch(teamTournamentSearchFilterProvider);
  final result = await getByClub(
    contextKey,
    filterProviderState.clubID,
  );

  return result;
});

class SearchByClub extends ConsumerWidget {
  const SearchByClub({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TeamTournamentFilter filterProviderState =
        ref.watch(teamTournamentSearchFilterProvider);
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    final futureAsyncValue = ref.watch(clubProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 12,
          ),
          CustomAutoFill(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            hint: "Søg efter klub",
            provider: teamTournamentFilterProvider,
            providerKey: "club",
            onSubmitted: (item) {
              ref.read(teamTournamentSearchFilterProvider.notifier).state =
                  filterProviderState.copyWith(
                clubID: item.isEmpty
                    ? null
                    : clubs
                        .firstWhere((e) => e.fullClubName == item)
                        .clubId
                        .toString(),
              );
            },
            converter: {
              for (var element in clubs)
                element.fullClubName: element.clubId.toString(),
            },
            suggestions: clubs.map((e) => e.fullClubName).toList(),
          ),
          (filterProviderState.clubID.isEmpty)
              ? const Expanded(
                  child: Center(
                    child: Text("Vælg årgang og badminton kreds for at søge"),
                  ),
                )
              : Expanded(
                  child: futureAsyncValue.when(
                    data: (data) => ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (context, index) => Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              colorThemeState.fontColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadiusDirectional.circular(2),
                        ),
                        height: 0.25,
                      ),
                      itemBuilder: (context, index) {
                        final club = data[index];
                        return Material(
                          color: colorThemeState.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${club.ageGroup} - ${club.teamName}",
                                          style: TextStyle(
                                            color: colorThemeState.fontColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          club.poolName,
                                          style: TextStyle(
                                            color: colorThemeState.fontColor
                                                .withAlpha(128),
                                            fontSize: 14,
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
                        );
                      },
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text("Fejl ved hentning af data: $error"),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
