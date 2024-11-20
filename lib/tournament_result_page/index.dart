import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/tournament_result.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/modal_bottom_sheet.dart';
import 'package:app/calendar/widgets/custom_expander.dart';
import 'package:app/calendar/widgets/drop_down_selector.dart';
import 'package:app/tournament_result_page/functions/get_results.dart';
import 'package:app/tournament_result_page/widgets/result.dart';
import 'package:app/tournament_result_page/widgets/result_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Map<String, dynamic>> tournamentResultFilterProvider =
    StateProvider<Map<String, dynamic>>(
  (ref) => {
    "clientselectfunction": "SelectTournamentClass1",
    "clubid": 0,
    "groupnumber": 0,
    "locationnumber": 0,
    "playerid": 0,
    "tabnumber": 0,
    "tournamentclassid": "",
    "tournamenteventid": 0,
  },
);

StateProvider<Map<String, Map<String, dynamic>>> resultFilterProvider =
    StateProvider<Map<String, Map<String, dynamic>>>((ref) => {});

FutureProvider<List<TournamentResult>> tournamentResultProvider =
    FutureProvider<List<TournamentResult>>((ref) async {
  final filterProvider = ref.watch(tournamentResultFilterProvider);
  final selectedTournamentState = ref.watch(selectedTournament);
  final result =
      await getResults(filterProvider, contextKey, selectedTournamentState);

  if (ref.read(resultFilterProvider.notifier).state.isEmpty) {
    ref.read(resultFilterProvider.notifier).state = result['filters'];
  }

  return result['results'];
});

class TournamentResultPage extends ConsumerWidget {
  final String tournamentTitle;

  const TournamentResultPage({super.key, required this.tournamentTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    AsyncValue<List<TournamentResult>> futureAsyncValue =
        ref.watch(tournamentResultProvider);
    Map<String, Map<String, dynamic>> resultFilterProviderState =
        ref.watch(resultFilterProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorThemeState.secondaryColor,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: colorThemeState.secondaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: Text(
                        tournamentTitle,
                        style: TextStyle(
                          color: colorThemeState.secondaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                    ),
                    child: InkWell(
                      onTap: resultFilterProviderState.entries.isEmpty
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              ref.read(isExpandedProvider.notifier).state = {};

                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => FilterBottomSheet(
                                  children: [
                                    CustomExpander(
                                      body: CustomDropDownSelector(
                                        data: resultFilterProviderState['class']
                                                ?.map((key, value) => MapEntry(
                                                    key, value.toString())) ??
                                            {},
                                        provider:
                                            tournamentResultFilterProvider,
                                        providerKey: "tournamentclassid",
                                        hint: "Vælg Række",
                                      ),
                                      header: Text(
                                        "Række",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: colorThemeState.secondaryColor,
                                        ),
                                      ),
                                      isExpandedKey: "Række",
                                    ),
                                    //! Opdatér når klub søgning virker igen
                                    // CustomExpander(
                                    //   body: CustomDropDownSelector(
                                    //     data: resultFilterProviderState['club']
                                    //             ?.map((key, value) => MapEntry(
                                    //                 key, value.toString())) ??
                                    //         {},
                                    //     provider:
                                    //         tournamentResultFilterProvider,
                                    //     providerKey: "clubid",
                                    //     hint: "Vælg Klub",
                                    //   ),
                                    //   header: Text(
                                    //     "Klub",
                                    //     style: TextStyle(
                                    //       fontSize: 24,
                                    //       fontWeight: FontWeight.w600,
                                    //       color: colorThemeState.secondaryColor,
                                    //     ),
                                    //   ),
                                    //   isExpandedKey: "Klub",
                                    // ),
                                    CustomExpander(
                                      body: CustomDropDownSelector(
                                        data: resultFilterProviderState[
                                                    'player']
                                                ?.map((key, value) => MapEntry(
                                                    key, value.toString())) ??
                                            {},
                                        provider:
                                            tournamentResultFilterProvider,
                                        providerKey: "playerid",
                                        hint: "Vælg Spiller",
                                      ),
                                      header: Text(
                                        "Spiller",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: colorThemeState.secondaryColor,
                                        ),
                                      ),
                                      isExpandedKey: "Spiller",
                                    )
                                  ],
                                ),
                              );
                            },
                      child: AnimatedOpacity(
                        opacity:
                            resultFilterProviderState.entries.isEmpty ? 0.5 : 1,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.tune,
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
                children: [
                  for (var filter in (resultFilterProviderState['matchType']
                          ?.keys
                          .toList() ??
                      []))
                    ResultLabel(
                      label: filter,
                      index:
                          resultFilterProviderState['matchType']?[filter] ?? 0,
                    ),
                ],
              ),
            ),
            futureAsyncValue.when(
              data: (data) {
                return data.isNotEmpty
                    ? Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: CustomExpander(
                                    selfSpaced: true,
                                    body: Column(
                                      children: [
                                        for (MatchResult match
                                            in data[index].matches)
                                          ResultWidget(result: match)
                                      ],
                                    ),
                                    header: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                      ),
                                      child: Text(
                                        data[index].resultName,
                                        style: TextStyle(
                                          color: colorThemeState.secondaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    isExpandedKey: data[index].resultName,
                                    isExpanded: true,
                                  ),
                                ),
                                itemCount: data.length,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                            "Der er sket en fejl, udvikleren er underrete, prøv igen senere"),
                      );
              },
              loading: () => const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Text(
                  error.toString(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
