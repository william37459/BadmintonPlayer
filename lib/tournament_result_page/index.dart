import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/tournament_result.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/modal_bottom_sheet.dart';
import 'package:app/calendar/widgets/custom_expander.dart';
import 'package:app/tournament_result_page/functions/get_results.dart';
import 'package:app/tournament_result_page/widgets/result.dart';
import 'package:app/tournament_result_page/widgets/result_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Map<String, Map<String, dynamic>>> resultFilterProvider =
    StateProvider<Map<String, Map<String, dynamic>>>((ref) => {});

StateProvider<Map<String, dynamic>> tournamentResultFilterProvider =
    StateProvider<Map<String, dynamic>>((ref) {
  return {
    "clientselectfunction": "SelectTournamentClass1",
    "clubid": 0,
    "groupnumber": 0,
    "locationnumber": 0,
    "playerid": 0,
    "tabnumber": 0,
    "tournamenteventid": 0,
  };
});

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.chevron_left,
                      color: colorThemeState.fontColor.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    tournamentTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorThemeState.fontColor,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: colorThemeState.fontColor.withValues(alpha: 0.8),
                      size: 24,
                    ),
                  ),
                ],
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
                        index: resultFilterProviderState['matchType']
                                ?[filter] ??
                            0,
                      ),
                  ],
                ),
              ),
              futureAsyncValue.when(
                data: (data) {
                  return data.isNotEmpty
                      ? Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 16,
                            ),
                            itemBuilder: (context, index) => CustomExpander(
                              selfSpaced: true,
                              body: Column(
                                spacing: 8,
                                children: [
                                  for (MatchResult match in data[index].matches)
                                    ResultWidget(
                                      result: match,
                                      pool: data[index].resultName,
                                    )
                                ],
                              ),
                              header: Text(
                                data[index].resultName,
                                style: TextStyle(
                                  color: colorThemeState.fontColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              isExpandedKey: data[index].resultName,
                              isExpanded: true,
                            ),
                            itemCount: data.length,
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
      ),
    );
  }
}
