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

Future<Map<String, dynamic>> showFilterModalSheet(
  BuildContext context,
  CustomColorTheme colorThemeState,
  WidgetRef ref,
) async {
  final StateProvider<Profile?> selectedPlayerProvider =
      StateProvider<Profile?>((ref) => null);

  Map<String, dynamic> filter = {
    "seasonId": null,
    "ageGroupList": [],
    "classIdList": [],
    "clubIds": null,
    "geoRegionIdList": null,
    "playerId": null,
  };

  await showDialog(
    context: context,
    builder: (context) => Center(
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
                      filter["seasonId"] = season.seasonId.toString(),
                  compareFn: (season1, season2) => season1.name == season2.name,
                ),
                const SizedBox(height: 12),
                const Text("Årgang"),
                CustomDropDownSelector<AgeGroup>(
                  isMultiSelect: true,
                  itemAsString: (item) => item.ageGroupName,
                  items: (filter, props) => seasonPlanSearchFilter.ageGroups,
                  hint: "Vælg årgange",
                  onChanged: (item) => print(item),
                  compareFn: (item1, item2) =>
                      item1.ageGroupName == item2.ageGroupName,
                ),
                const SizedBox(height: 12),
                const Text("Række"),
                CustomDropDownSelector(
                  itemAsString: (item) => (item).className,
                  items: (filter, props) => seasonPlanSearchFilter.classGroups,
                  hint: "Vælg rækker",
                  onChanged: (item) => print(item),
                  isMultiSelect: true,
                  compareFn: (item1, item2) =>
                      (item1).className == (item2).className,
                  itemBuilder: (context, item, isDisabled, isSelected) =>
                      ListTile(
                        title: Text(
                          (item).className,
                          style: TextStyle(color: colorThemeState.fontColor),
                        ),
                      ),
                ),
                const SizedBox(height: 12),
                const Text("Arrangør"),
                CustomDropDownSelector(
                  itemAsString: (item) => (item).clubName,
                  items: (filter, props) => clubs,
                  hint: "Vælg sæson",
                  onChanged: (item) =>
                      filter["clubIds"] = (item as Club).clubId.toString(),
                  compareFn: (item1, item2) =>
                      (item1).clubName == (item2).clubName,
                  itemBuilder: (context, item, isDisabled, isSelected) =>
                      ListTile(
                        title: Text(
                          (item).clubName,
                          style: TextStyle(color: colorThemeState.fontColor),
                        ),
                      ),
                ),

                const SizedBox(height: 12),
                const Text("Område"),
                CustomDropDownSelector(
                  itemAsString: (item) => (item).name,
                  items: (filter, props) => seasonPlanSearchFilter.geoRegions,
                  hint: "Vælg område",
                  onChanged: (item) => filter["geoRegionIdList"] =
                      (item as GeoRegion).geoRegionID.toString(),
                  compareFn: (item1, item2) => (item1).name == (item2).name,
                  itemBuilder: (context, item, isDisabled, isSelected) =>
                      ListTile(
                        title: Text(
                          (item).name,
                          style: TextStyle(color: colorThemeState.fontColor),
                        ),
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
                        filter["geoRegionIdList"] = selectedPlayer?.id;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                      selectedPlayer?.name ?? "Vælg spiller",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: colorThemeState.fontColor
                                            .withValues(
                                              alpha: selectedPlayer == null
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

                                color: colorThemeState.fontColor.withValues(
                                  alpha: 0.5,
                                ),
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
                        Navigator.of(context).pop(filter);
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
  return filter;
}
