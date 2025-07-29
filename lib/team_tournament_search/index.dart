import 'package:app/global/classes/club.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/drop_down_selector.dart';
import 'package:app/team_tournament_results/club/index.dart';
import 'package:app/team_tournament_search/widgets/team_tournament_team_widget.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamTournamentSearch extends ConsumerWidget {
  final TextEditingController textFieldController = TextEditingController();
  final GlobalKey<AutoCompleteTextFieldState<String>> textFieldKey =
      GlobalKey<AutoCompleteTextFieldState<String>>();

  final FocusNode textFieldFocusNode = FocusNode();

  TeamTournamentSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    final futureAsyncValue = ref.watch(teamTournaments);

    return Scaffold(
      backgroundColor: colorThemeState.backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorThemeState.primaryColor,
        icon: Icon(Icons.save, color: colorThemeState.secondaryFontColor),
        label: Text(
          "Færdig",
          style: TextStyle(
            color: colorThemeState.secondaryFontColor,
            fontSize: 16,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          ref
              .read(teamTournamentSearchFilterProvider.notifier)
              .state = TeamTournamentFilter.fromJson({
            ...ref
                .read(teamTournamentSearchFilterProvider.notifier)
                .state
                .toJson(),
            "clubID": "",
          });
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Holdkamps søgning",
                    style: TextStyle(
                      color: colorThemeState.fontColor.withValues(alpha: 0.8),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomDropDownSelector<Club>(
                itemAsString: (item) => (item).clubName,
                items: (filter, props) => clubs,
                compareFn: (item1, item2) =>
                    (item1).clubName == (item2).clubName,
                hint: "Søg efter klub",
                initalValue: null,
                onChanged: (item) {
                  ref
                      .read(teamTournamentSearchFilterProvider.notifier)
                      .state = TeamTournamentFilter.fromJson({
                    ...ref
                        .read(teamTournamentSearchFilterProvider.notifier)
                        .state
                        .toJson(),
                    "clubID": item.clubId.toString(),
                  });
                },
              ),
            ),
            Expanded(
              child: futureAsyncValue.when(
                data: (data) => (data[data.keys.first]?.length ?? 0) < 2
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Søg efter en klub for at følge en holdkamp",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            for (String key in data.keys)
                              for (TeamTournamentFilterClub result
                                  in data[key] ?? [])
                                TeamTournamentTeamWidget(result: result),
                          ],
                        ),
                      ),
                error: (error, stackTrace) => const Text("error"),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
