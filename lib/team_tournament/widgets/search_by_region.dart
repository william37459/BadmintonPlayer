import 'package:app/global/widgets/drop_down_selector.dart';
import 'package:app/global/classes/team_tournament_region.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament/functions/get_by_region.dart';
import 'package:app/team_tournament_results/club_result/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FutureProvider<List<TeamTournamentRegion>> regionProvider =
    FutureProvider<List<TeamTournamentRegion>>((ref) async {
      final filterProviderState = ref.watch(teamTournamentSearchFilterProvider);
      final result = await getByRegion(
        contextKey,
        filterProviderState.ageGroupID,
        filterProviderState.regionID,
      );

      return result;
    });

class SearchByRegion extends ConsumerWidget {
  final List<Map<String, String>> data;
  const SearchByRegion({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterProviderState = ref.watch(teamTournamentSearchFilterProvider);
    final futureAsyncValue = ref.watch(regionProvider);
    final colorThemeState = ref.watch(colorThemeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CustomDropDownSelector<Map<String, dynamic>>(
                    hint: "Badminton kreds",
                    itemAsString: (item) => item.values.first,
                    items: (filter, props) => data[0].entries
                        .map((entry) => {entry.key: entry.value})
                        .toList(),
                    initalValue: null,
                    compareFn: (item1, item2) =>
                        item1.values.first == item2.values.first,
                    itemBuilder: (context, item, isDisabled, isSelected) =>
                        ListTile(
                          title: Text(
                            (item as Map).values.first,
                            style: TextStyle(color: colorThemeState.fontColor),
                          ),
                        ),
                    onChanged: (value) {
                      ref
                          .read(teamTournamentSearchFilterProvider.notifier)
                          .state = filterProviderState.copyWith(
                        regionID: value.keys.first,
                      );
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomDropDownSelector(
                    hint: "Årgang",
                    onChanged: (value) {
                      ref
                          .read(teamTournamentSearchFilterProvider.notifier)
                          .state = filterProviderState.copyWith(
                        ageGroupID: value.keys.first,
                      );
                    },
                    itemAsString: (item) => item.values.first,
                    compareFn: (item1, item2) =>
                        item1.values.first == item2.values.first,
                    itemBuilder: (context, item, isDisabled, isSelected) =>
                        ListTile(
                          title: Text(
                            (item as Map).values.first,
                            style: TextStyle(color: colorThemeState.fontColor),
                          ),
                        ),
                    items: (filter, props) => data[1].entries
                        .map((entry) => {entry.key: entry.value})
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          (filterProviderState.ageGroupID.isEmpty ||
                  filterProviderState.regionID.isEmpty)
              ? const Expanded(
                  child: Center(
                    child: Text("Vælg årgang og badminton kreds for at søge"),
                  ),
                )
              : Expanded(
                  child: futureAsyncValue.when(
                    data: (data) => data.isEmpty
                        ? const Center(
                            child: Text(
                              "Der er ingen holdkampe i denne region",
                            ),
                          )
                        : ListView.separated(
                            itemCount: data.length,
                            separatorBuilder: (context, index) => Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: colorThemeState.fontColor.withValues(
                                  alpha: 0.5,
                                ),
                                borderRadius: BorderRadiusDirectional.circular(
                                  2,
                                ),
                              ),
                              height: 0.25,
                            ),
                            itemBuilder: (context, index) {
                              final region = data[index];
                              return Material(
                                color: colorThemeState.backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    ref.read(selectedLeague.notifier).state =
                                        int.tryParse(
                                          region.filter.leagueGroupID,
                                        ) ??
                                        -1;
                                    Navigator.pushNamed(
                                      context,
                                      "/TeamTournamentClubPage",
                                      arguments: {"header": region.pool},
                                      // arguments: club,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              region.header,
                                              style: TextStyle(
                                                color:
                                                    colorThemeState.fontColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              region.pool,
                                              style: TextStyle(
                                                color: colorThemeState.fontColor
                                                    .withAlpha(128),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
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
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
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
