import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/tab_bar_label.dart';
import 'package:app/team_tournament/functions/get_setup_team_tournaments.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/calendar/widgets/custom_input.dart';
import 'package:app/team_tournament/widgets/search_by_club.dart';
import 'package:app/team_tournament/widgets/search_by_number.dart';
import 'package:app/team_tournament/widgets/search_by_region.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// const SizedBox(height: 12),
// Row(
//   children: [
//     Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Text(
//         "Sæson:",
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 18,
//           color: colorThemeState.secondaryColor
//               .withValues(alpha: 0.75),
//         ),
//       ),
//     ),
//     Expanded(
//       child: CustomDropDownSelector(
//         data: data[2],
//         provider: teamTournamentFilterProvider,
//         providerKey: "season",
//         hint: "Vælg sæson",
//       ),
//     ),
//   ],
// ),

StateProvider<int> currentIndex = StateProvider((ref) => 0);

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

StateProvider<bool> showingSearch = StateProvider((ref) => false);

FutureProvider<List<Map<String, String>>> seasonPlanFutureProvider =
    FutureProvider<List<Map<String, String>>>((ref) async {
  final result = await getSetupTeamTournaments();
  return result;
});

late TabController tabController;

class TeamTournamentPage extends ConsumerStatefulWidget {
  const TeamTournamentPage({
    super.key,
  });

  @override
  TeamTournamentPageState createState() => TeamTournamentPageState();
}

class TeamTournamentPageState extends ConsumerState
    with SingleTickerProviderStateMixin {
  final GlobalKey<AutoCompleteTextFieldState<String>> textFieldKey =
      GlobalKey<AutoCompleteTextFieldState<String>>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);

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
    final Map<String, dynamic> filterProviderState =
        ref.watch(teamTournamentFilterProvider);

    final futureAsyncValue = ref.watch(seasonPlanFutureProvider);
    final showingSearchState = ref.watch(showingSearch);
    final currentIndexState = ref.watch(currentIndex);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Holdkamp",
                  style: TextStyle(
                    color: colorThemeState.fontColor.withValues(alpha: 0.8),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 16,
                ),
                TabBarLabel(
                  label: "Badminton Kreds",
                  index: 0,
                  tabController: tabController,
                  currentIndex: currentIndexState,
                ),
                TabBarLabel(
                  label: "Klub",
                  index: 1,
                  tabController: tabController,
                  currentIndex: currentIndexState,
                ),
                TabBarLabel(
                  label: "Kampnummer",
                  index: 2,
                  tabController: tabController,
                  currentIndex: currentIndexState,
                ),
              ],
            ),
          ),
          Expanded(
            child: futureAsyncValue.when(
              data: (data) => TabBarView(
                controller: tabController,
                children: [
                  SearchByRegion(data: data),
                  const SearchByClub(),
                  const SearchByNumber(),
                ],
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
