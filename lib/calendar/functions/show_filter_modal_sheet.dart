import 'package:app/calendar/classes/season_plan_search_filter.dart';
import 'package:app/calendar/index.dart';
import 'package:app/global/classes/club.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/classes/search_filters/age_group.dart';
import 'package:app/global/classes/search_filters/class_group.dart';
import 'package:app/global/classes/search_filters/region.dart';
import 'package:app/global/classes/search_filters/seasons.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/drop_down_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showFilterModalSheet(
  BuildContext context,
  CustomColorTheme colorThemeState,
  WidgetRef ref,
) async {
  final StateProvider<Profile?> selectedPlayerProvider =
      StateProvider<Profile?>(
        (ref) => ref.read(seasonPlanSeachFilterProvider).player,
      );

  bool? shouldUpdate = await showDialog<bool?>(
    context: context,
    builder: (context) => Consumer(
      builder: (context, ref, child) {
        final SeasonPlanSearchFilter seasonPlanSeachFilterState = ref.watch(
          seasonPlanSeachFilterProvider,
        );
        return SafeArea(
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(8),
              color: colorThemeState.backgroundColor,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.close, color: Colors.transparent),
                          const Text("Filtrer", style: TextStyle(fontSize: 20)),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const Text("Sæson"),
                      CustomDropDownSelector<Season>(
                        itemAsString: (season) => season.name,
                        items: (filter, props) =>
                            seasonPlanSearchFilter.seasons.reversed.toList(),
                        hint: "Vælg sæson",
                        onChanged: (season) =>
                            ref
                                .read(seasonPlanSeachFilterProvider.notifier)
                                .state = seasonPlanSeachFilterState.copyWith(
                              season: season as Season?,
                            ),
                      ),
                      const SizedBox(height: 12),
                      const Text("Årgang"),
                      CustomDropDownSelector<AgeGroup>(
                        isMultiSelect: true,
                        itemAsString: (item) => item.ageGroupName,
                        items: (filter, props) =>
                            seasonPlanSearchFilter.ageGroups,
                        hint: "Vælg årgange",
                        selectedItems: seasonPlanSeachFilterState.ageGroupList,

                        onChanged: (item) =>
                            ref
                                .read(seasonPlanSeachFilterProvider.notifier)
                                .state = seasonPlanSeachFilterState.copyWith(
                              ageGroupList: item as List<AgeGroup>?,
                            ),
                      ),
                      const SizedBox(height: 12),
                      const Text("Række"),
                      CustomDropDownSelector<Class>(
                        itemAsString: (item) => (item).className,
                        items: (filter, props) =>
                            seasonPlanSearchFilter.classGroups,
                        hint: "Vælg rækker",
                        selectedItems: seasonPlanSeachFilterState.classList,
                        onChanged: (item) =>
                            ref
                                .read(seasonPlanSeachFilterProvider.notifier)
                                .state = seasonPlanSeachFilterState.copyWith(
                              classList: item as List<Class>?,
                            ),
                        isMultiSelect: true,
                      ),
                      const SizedBox(height: 12),
                      const Text("Arrangør"),
                      CustomDropDownSelector<Club>(
                        itemAsString: (item) => item.clubName,
                        items: (filter, props) => clubs,
                        hint: "Vælg sæson",
                        onChanged: (item) =>
                            ref
                                .read(seasonPlanSeachFilterProvider.notifier)
                                .state = seasonPlanSeachFilterState.copyWith(
                              clubs: [item as Club],
                            ),
                      ),
                      const SizedBox(height: 12),
                      const Text("Område"),
                      CustomDropDownSelector<GeoRegion>(
                        itemAsString: (item) => item.name,
                        isMultiSelect: true,
                        items: (filter, props) =>
                            seasonPlanSearchFilter.geoRegions,
                        hint: "Vælg område",
                        selectedItems:
                            seasonPlanSeachFilterState.geoRegionIdList ?? [],
                        onChanged: (item) =>
                            ref
                                .read(seasonPlanSeachFilterProvider.notifier)
                                .state = seasonPlanSeachFilterState.copyWith(
                              geoRegionIdList: item as List<GeoRegion>?,
                            ),
                      ),
                      const SizedBox(height: 12),
                      const Text("Turneringer i din egn"),
                      CustomDropDownSelector<Region>(
                        itemAsString: (item) => item.name,
                        isMultiSelect: true,
                        items: (filter, props) =>
                            seasonPlanSearchFilter.regions,
                        hint: "Vælg egn",
                        selectedItems:
                            seasonPlanSeachFilterState.regionIdList ?? [],
                        onChanged: (item) =>
                            ref
                                .read(seasonPlanSeachFilterProvider.notifier)
                                .state = seasonPlanSeachFilterState.copyWith(
                              regionIdList: item as List<Region>?,
                            ),
                      ),
                      const SizedBox(height: 12),
                      const Text("Spiller"),
                      Container(
                        height: 41,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorThemeState.inputFieldColor,
                          borderRadius: BorderRadius.circular(48),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(48),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () async {
                              Profile? selectedPlayer =
                                  await Navigator.of(context).pushNamed(
                                        "/PlayerSearchPage",
                                        arguments: {"shouldReturnPlayer": true},
                                      )
                                      as Profile?;
                              ref.read(selectedPlayerProvider.notifier).state =
                                  selectedPlayer;

                              if (selectedPlayer != null) {
                                ref
                                    .read(
                                      seasonPlanSeachFilterProvider.notifier,
                                    )
                                    .state = seasonPlanSeachFilterState
                                    .copyWith(
                                      player: selectedPlayer,
                                      ageGroupList: [],
                                      classList: [],
                                    );
                              } else {
                                ref
                                    .read(
                                      seasonPlanSeachFilterProvider.notifier,
                                    )
                                    .state = seasonPlanSeachFilterState
                                    .copyWith(player: selectedPlayer);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Consumer(
                                        builder: (context, ref, child) {
                                          Profile? selectedPlayer = ref.watch(
                                            selectedPlayerProvider,
                                          );
                                          return Text(
                                            selectedPlayer?.name ??
                                                "Vælg spiller",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: colorThemeState.fontColor
                                                  .withValues(
                                                    alpha:
                                                        selectedPlayer == null
                                                        ? 0.5
                                                        : 1,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_sharp,

                                      color: colorThemeState.fontColor
                                          .withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: colorThemeState.primaryColor,
                          borderRadius: BorderRadius.circular(32),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8,
                              ),
                              child: Text(
                                "Søg",
                                style: TextStyle(
                                  color: colorThemeState.secondaryFontColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
  if (shouldUpdate == true) {
    ref.invalidate(seasonPlanFutureProvider);
  }
  return;
}
