import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_score.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/score_list/functions/get_score_list.dart';
import 'package:app/score_list/functions/show_filter_modal_sheet.dart';
import 'package:app/score_list/widgets/ranking_list.dart';
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
StateProvider<bool> showingSearch = StateProvider((ref) => false);

FutureProvider<Map<String, List<PlayerScore>>> allScoreListProvider =
    FutureProvider<Map<String, List<PlayerScore>>>((ref) async {
  final rankFilterProviderState = ref.watch(rankFilterProvider);
  final result = await getAllScoreLists(rankFilterProviderState);
  return result;
});

class ScoreList extends ConsumerStatefulWidget {
  const ScoreList({
    super.key,
  });

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

    bool showingSearchState = ref.watch(showingSearch);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rangliste",
                  style: TextStyle(
                    color: colorThemeState.fontColor.withValues(alpha: 0.8),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(showingSearch.notifier).state =
                      !showingSearchState,
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: showingSearchState
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Icon(
                      Icons.close,
                      color: colorThemeState.fontColor.withValues(alpha: 0.8),
                    ),
                    secondChild: Icon(
                      Icons.search,
                      color: colorThemeState.fontColor.withValues(alpha: 0.8),
                    ),
                  ),
                )
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: showingSearchState
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            secondChild: Container(),
            firstChild: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffEBEBEB),
                borderRadius: BorderRadius.circular(48),
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
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(4),
                        isDense: true,
                        isCollapsed: true,
                        hintText: "Søg efter klub",
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
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
                          showFilterModalSheet(
                            context,
                            rankSearchFilters,
                            colorThemeState,
                            rankFilterProvider,
                            ref,
                          );
                        },
                        child: Icon(
                          Icons.tune,
                          size: 18,
                          color: colorThemeState.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                SizedBox(
                  width: 16,
                ),
                TabBarLabel(label: "Alle", index: 0),
                TabBarLabel(label: "Herresingle", index: 1),
                TabBarLabel(label: "Damesingle", index: 2),
                TabBarLabel(label: "Herredouble", index: 3),
                TabBarLabel(label: "Damedouble", index: 4),
                TabBarLabel(label: "Mixeddouble Herre", index: 5),
                TabBarLabel(label: "Mixeddouble Dame", index: 6),
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
                                  ref.read(rankFilterProvider.notifier).state =
                                      {
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
                                      color: colorThemeState.secondaryFontColor,
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: currentIndexState == index
                      ? colorThemeState.primaryColor
                      : colorThemeState.fontColor.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: currentIndexState == index
                    ? colorThemeState.primaryColor
                    : colorThemeState.fontColor.withValues(alpha: 0.8),
                fontWeight: currentIndexState == index
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
