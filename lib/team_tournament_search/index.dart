import 'package:app/global/widgets/custom_container.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
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

  TeamTournamentSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    final futureAsyncValue = ref.watch(teamTournaments);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorThemeState.primaryColor,
        icon: Icon(
          Icons.save,
          color: colorThemeState.secondaryFontColor,
        ),
        label: Text(
          "Færdig",
          style: TextStyle(
            color: colorThemeState.secondaryFontColor,
            fontSize: 16,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomContainer(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: AutoCompleteTextField<String>(
                      autofocus: true,
                      focusNode: textFieldFocusNode,
                      key: textFieldKey,
                      controller: textFieldController,
                      suggestions: clubs.map((e) => e.fullClubName).toList(),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colorThemeState.primaryColor
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colorThemeState.primaryColor,
                          ),
                        ),
                        isDense: true,
                        isCollapsed: true,
                        hintText: "Søg efter klub",
                        hintStyle: const TextStyle(),
                      ),
                      itemFilter: (item, query) {
                        return item.toLowerCase().contains(query.toLowerCase());
                      },
                      itemSorter: (a, b) {
                        return b.compareTo(a);
                      },
                      unFocusOnItemSubmitted: true,
                      itemSubmitted: (item) {
                        final club = clubs.firstWhere(
                          (element) => element.fullClubName == item,
                        );
                        ref
                            .read(teamTournamentSearchFilterProvider.notifier)
                            .state = TeamTournamentFilter.fromJson({
                          ...ref
                              .read(teamTournamentSearchFilterProvider.notifier)
                              .state
                              .toJson(),
                          "clubID": club.clubId.toString(),
                        });
                      },
                      textSubmitted: (data) {},
                      itemBuilder: (context, item) {
                        return ListTile(
                          title: Text(item),
                        );
                      },
                    ),
                  ),
                ],
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
                                TeamTournamentTeamWidget(
                                  result: result,
                                )
                          ],
                        ),
                      ),
                error: (error, stackTrace) => const Text("error"),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
