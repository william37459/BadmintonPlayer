import 'package:app/global/classes/club.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_score.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/drop_down_selector.dart';
import 'package:app/global/widgets/tab_bar_label.dart';
import 'package:app/score_list/functions/get_score_list.dart';
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
        "seasonid": season,
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
  final StateProvider<Profile?> selectedPlayer = StateProvider<Profile?>(
    (ref) => null,
  );

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
    AsyncValue<Map<String, List<PlayerScore>>> futureAsyncValue = ref.watch(
      allScoreListProvider,
    );

    bool showingSearchState = ref.watch(showingSearch);
    final int currentIndexState = ref.watch(currentIndex);

    return Container(
      color: colorThemeState.backgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: showingSearchState
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              secondChild: Container(),
              firstChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomDropDownSelector<Club>(
                  itemAsString: (item) => (item).clubName,
                  items: (filter, props) => clubs,
                  compareFn: (item1, item2) =>
                      (item1).clubName == (item2).clubName,
                  hint: "Søg efter klub",
                  initalValue: null,
                  onChanged: (item) {
                    ref.read(rankFilterProvider.notifier).state = {
                      ...ref.read(rankFilterProvider.notifier).state,
                      "clubid": (item as Club).clubId,
                    };
                  },
                ),
              ),
            ),
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 16),
                  TabBarLabel(
                    label: "Alle",
                    index: 0,
                    currentIndex: currentIndexState,
                    tabController: tabController,
                  ),
                  TabBarLabel(
                    label: "Herresingle",
                    index: 1,
                    currentIndex: currentIndexState,
                    tabController: tabController,
                  ),
                  TabBarLabel(
                    label: "Damesingle",
                    index: 2,
                    currentIndex: currentIndexState,
                    tabController: tabController,
                  ),
                  TabBarLabel(
                    label: "Herredouble",
                    index: 3,
                    currentIndex: currentIndexState,
                    tabController: tabController,
                  ),
                  TabBarLabel(
                    label: "Damedouble",
                    index: 4,
                    currentIndex: currentIndexState,
                    tabController: tabController,
                  ),
                  TabBarLabel(
                    label: "Mixeddouble Herre",
                    index: 5,
                    currentIndex: currentIndexState,
                    tabController: tabController,
                  ),
                  TabBarLabel(
                    label: "Mixeddouble Dame",
                    index: 6,
                    currentIndex: currentIndexState,
                    tabController: tabController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            futureAsyncValue.when(
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Expanded(
                child: Center(child: CircularProgressIndicator()),
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
                              const SizedBox(height: 16),
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
                                      "seasonid": season,
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
