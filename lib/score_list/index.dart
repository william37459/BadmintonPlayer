import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_score.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/modal_bottom_sheet.dart';
import 'package:app/player_profile_search/index.dart';
import 'package:app/score_list/functions/get_score_list.dart';
import 'package:app/score_list/widgets/ranking_list.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/calendar/widgets/custom_date_picker.dart';
import 'package:app/calendar/widgets/custom_expander.dart';
import 'package:app/calendar/widgets/custom_input.dart';
import 'package:app/calendar/widgets/drop_down_selector.dart';
import 'package:app/calendar/widgets/wrapper_selector.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Map<String, dynamic>> rankFilterProvider =
    StateProvider<Map<String, dynamic>>(
  (ref) => {
    "agefrom": null,
    "agegroupid": "",
    "ageto": null,
    "birthdatefromstring": "",
    "birthdatetostring": "",
    "classid": "",
    "clubid": "",
    "gender": "",
    "getplayer": true,
    "getversions": true,
    "pageindex": 0,
    "param": "",
    "playerid": "",
    "pointsfrom": "",
    "pointsto": "",
    "rankingfrom": "",
    "rankinglistagegroupid": "15",
    "rankinglistid": "287",
    "rankinglistversiondate": "",
    "rankingto": "",
    "regionid": "",
    "searchall": false,
    "seasonid": "2023",
    "sortfield": 0,
  },
);

StateProvider<List<String>> likedIds = StateProvider((ref) => []);
StateProvider<int> currentIndex = StateProvider((ref) => 0);

FutureProvider<Map<String, List<PlayerScore>>> allScoreListProvider =
    FutureProvider<Map<String, List<PlayerScore>>>((ref) async {
  final rankFilterProviderState = ref.watch(rankFilterProvider);
  final result = await getAllScoreLists(rankFilterProviderState);
  return result;
});

class ScoreList extends ConsumerStatefulWidget {
  const ScoreList({super.key});

  @override
  ScoreListState createState() => ScoreListState();
}

late TabController tabController;

class ScoreListState extends ConsumerState with SingleTickerProviderStateMixin {
  late CustomColorTheme colorThemeState;
  final TextEditingController textFieldController = TextEditingController();
  final GlobalKey<AutoCompleteTextFieldState<String>> textFieldKey =
      GlobalKey<AutoCompleteTextFieldState<String>>();

  final FocusNode textFieldFocusNode = FocusNode();
  final StateProvider<Profile?> selectedPlayer =
      StateProvider<Profile?>((ref) => null);

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 7);

    tabController.addListener(() {
      ref.read(currentIndex.notifier).state = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    AsyncValue<Map<String, List<PlayerScore>>> futureAsyncValue =
        ref.watch(allScoreListProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12,
              ),
              child: Text(
                "Rangliste",
                style: TextStyle(
                  color: colorThemeState.secondaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AutoCompleteTextField<String>(
                      autofocus: true,
                      focusNode: textFieldFocusNode,
                      key: textFieldKey,
                      controller: textFieldController,
                      clearOnSubmit: false,
                      suggestions: listOfclubs,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(4),
                        isDense: true,
                        isCollapsed: true,
                        hintText: "Søg efter klub",
                      ),
                      itemFilter: (item, query) {
                        return item.toLowerCase().contains(query.toLowerCase());
                      },
                      itemSorter: (a, b) {
                        return b.compareTo(a);
                      },
                      unFocusOnItemSubmitted: true,
                      itemSubmitted: (item) {
                        ref.read(rankFilterProvider.notifier).state = {
                          ...ref.read(rankFilterProvider.notifier).state,
                          "clubid": "clubs[item]" //TODO FIKS?!,
                        };
                      },
                      textSubmitted: (data) {
                        if (data.isEmpty) {
                          ref.read(rankFilterProvider.notifier).state = {
                            ...ref.read(rankFilterProvider.notifier).state,
                            "clubid": "",
                          };
                        }
                      },
                      itemBuilder: (context, item) {
                        return ListTile(
                          title: Text(item),
                        );
                      },
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          ref.read(isExpandedProvider.notifier).state = {};

                          for (String key
                              in ref.read(rankFilterProvider).keys) {
                            ref.read(isExpandedProvider.notifier).state = {
                              ...ref.read(isExpandedProvider.notifier).state,
                              key: false,
                            };
                          }
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => FilterBottomSheet(
                              children: [
                                CustomExpander(
                                  isExpandedKey: "seasonid",
                                  header: Text(
                                    "Sæson",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: CustomDropDownSelector(
                                    data: rankSearchFilters['season'] ?? {},
                                    provider: rankFilterProvider,
                                    providerKey: "seasonid",
                                    hint: "Vælg sæson",
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "agegroupid",
                                  header: Text(
                                    "Årgang",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: WrapperSelector(
                                    data: rankSearchFilters['ageGroup'] ?? {},
                                    providerKey: "agegroupid",
                                    provider: rankFilterProvider,
                                    isMultiSelect: false,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "classid",
                                  header: Text(
                                    "Række",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: WrapperSelector(
                                    data: rankSearchFilters['class'] ?? {},
                                    providerKey: "classid",
                                    provider: rankFilterProvider,
                                    isMultiSelect: false,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "regionid",
                                  header: Text(
                                    "Kreds/Landsdel",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: CustomDropDownSelector(
                                    data: rankSearchFilters['geoRegions'] ?? {},
                                    providerKey: "regionid",
                                    provider: rankFilterProvider,
                                    hint: "Vælg kreds eller landsdel",
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "playerid",
                                  header: Text(
                                    "Spiller",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: CustomContainer(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 2,
                                    ),
                                    onTap: () async {
                                      Profile? value =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => PlayerSearch(
                                            shouldReturnPlayer: true,
                                          ),
                                        ),
                                      );

                                      ref.read(selectedPlayer.notifier).state =
                                          value;
// ref
                                      ref
                                          .read(rankFilterProvider.notifier)
                                          .state = {
                                        ...ref
                                            .read(rankFilterProvider.notifier)
                                            .state,
                                        "playerid": value?.id ?? "",
                                      };
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Consumer(
                                          builder: (context, ref, child) {
                                            Profile? selectedProfileState =
                                                ref.watch(selectedPlayer);
                                            return Text(
                                              selectedProfileState?.name ?? "",
                                            );
                                          },
                                        ),
                                        InkWell(
                                          onTap: () {
                                            ref
                                                .read(selectedPlayer.notifier)
                                                .state = null;
                                            ref
                                                .read(
                                                    rankFilterProvider.notifier)
                                                .state = {
                                              ...ref
                                                  .read(rankFilterProvider
                                                      .notifier)
                                                  .state,
                                              "playerid": "",
                                            };
                                          },
                                          child: const Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "pointsfrom",
                                  header: Text(
                                    "Point",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: Row(
                                    children: [
                                      Expanded(
                                        child: CustomInput(
                                          hint: "Minimum point",
                                          providerKey: "pointsfrom",
                                          provider: rankFilterProvider,
                                          inputType: TextInputType.number,
                                          min: 0,
                                          max: 10000,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                        ),
                                        child: Icon(
                                          Icons.more_horiz,
                                          color: colorThemeState.primaryColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomInput(
                                          min: 0,
                                          max: 10000,
                                          hint: "Max point",
                                          providerKey: "pointsto",
                                          provider: rankFilterProvider,
                                          inputType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "rankingfrom",
                                  header: Text(
                                    "Placering",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: Row(
                                    children: [
                                      Expanded(
                                        child: CustomInput(
                                          hint: "Minimum placering",
                                          providerKey: "rankingfrom",
                                          provider: rankFilterProvider,
                                          inputType: TextInputType.number,
                                          min: 0,
                                          max: 10000,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                        ),
                                        child: Icon(
                                          Icons.more_horiz,
                                          color: colorThemeState.primaryColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomInput(
                                          min: 0,
                                          max: 10000,
                                          hint: "Max placering",
                                          providerKey: "rankingto",
                                          provider: rankFilterProvider,
                                          inputType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "birthdatefromstring",
                                  header: Text(
                                    "Fødselsdato",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: Row(
                                    children: [
                                      Expanded(
                                        child: CustomDatePicker(
                                          hintText: "Fødselsdag fra",
                                          providerKey: "birthdatefromstring",
                                          provider: rankFilterProvider,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                        ),
                                        child: Icon(
                                          Icons.more_horiz,
                                          color: colorThemeState.primaryColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomDatePicker(
                                          hintText: "Fødselsdag til",
                                          providerKey: "birthdatetostring",
                                          provider: rankFilterProvider,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.tune,
                          size: 18,
                          color: colorThemeState.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  TabBarLabel(label: "Alle", index: 0),
                  TabBarLabel(label: "HS", index: 1),
                  TabBarLabel(label: "DS", index: 2),
                  TabBarLabel(label: "HD", index: 3),
                  TabBarLabel(label: "DD", index: 4),
                  TabBarLabel(label: "MD H", index: 5),
                  TabBarLabel(label: "MD D", index: 6),
                ],
              ),
            ),
            futureAsyncValue.when(
              error: (error, stackTrace) => Center(
                child: Text(
                  error.toString(),
                ),
              ),
              loading: () => const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              data: (data) {
                return data.values.any((value) => value.isNotEmpty)
                    ? Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            for (String playerKey in data.keys)
                              RankingList(playerScoreList: data[playerKey]!),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Der er ingen turneringer der matchede din søgning",
                                style: TextStyle(
                                  color: colorThemeState.fontColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Material(
                                color: colorThemeState.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .read(rankFilterProvider.notifier)
                                        .state = {
                                      "agefrom": null,
                                      "agegroupid": "",
                                      "ageto": null,
                                      "birthdatefromstring": "",
                                      "birthdatetostring": "",
                                      "classid": "",
                                      "clubid": "",
                                      "gender": "",
                                      "getplayer": true,
                                      "getversions": true,
                                      "pageindex": 0,
                                      "param": "",
                                      "playerid": "",
                                      "pointsfrom": "",
                                      "pointsto": "",
                                      "rankingfrom": "",
                                      "rankinglistagegroupid": "15",
                                      "rankinglistid": "287",
                                      "rankinglistversiondate": "",
                                      "rankingto": "",
                                      "regionid": "",
                                      "searchall": false,
                                      "seasonid": "2023",
                                      "sortfield": 0,
                                    };
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      "Nulstil filtré",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            colorThemeState.secondaryFontColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarLabel extends ConsumerWidget {
  final String label;
  final int index;
  const TabBarLabel({
    super.key,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    int currentIndexState = ref.watch(currentIndex);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            tabController.animateTo(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: currentIndexState == index
                  ? colorThemeState.primaryColor
                  : colorThemeState.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: currentIndexState == index
                    ? colorThemeState.secondaryFontColor
                    : colorThemeState.primaryColor,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
