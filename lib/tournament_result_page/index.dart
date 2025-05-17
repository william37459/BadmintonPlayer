import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/tournament_result.dart';
import 'package:app/global/constants.dart';
import 'package:app/calendar/widgets/custom_expander.dart';
import 'package:app/tournament_result_page/functions/get_results.dart';
import 'package:app/tournament_result_page/widgets/result.dart';
import 'package:app/tournament_result_page/widgets/result_label.dart';
import 'package:app/tournament_result_page/widgets/tournament_info_bottom_sheet.dart';
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

StateProvider<TournamentInfo?> tournamentInfoProvider =
    StateProvider<TournamentInfo?>((ref) => null);

FutureProvider<List<TournamentResult>> tournamentResultProvider =
    FutureProvider<List<TournamentResult>>((ref) async {
  final filterProvider = ref.watch(tournamentResultFilterProvider);
  final selectedTournamentState = ref.watch(selectedTournament);
  final result =
      await getResults(filterProvider, contextKey, selectedTournamentState);

  ref.read(tournamentInfoProvider.notifier).state = result['info'];

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
    TournamentInfo? tournamentInfo = ref.watch(tournamentInfoProvider);

    return Scaffold(
      backgroundColor: colorThemeState.backgroundColor,
      body: SafeArea(
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
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
                    onTap: tournamentInfo == null
                        ? null
                        : () => showModalBottomSheet(
                              context: context,
                              builder: (context) => TournamentInfoBottomSheet(
                                info: tournamentInfo,
                              ),
                            ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: colorThemeState.primaryColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 48,
              width: double.infinity,
              color: Colors.white,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final filters = resultFilterProviderState['matchType']!
                      .keys
                      .toList()
                      .sublist(0, 5);
                  double totalWidth = filters.length * 100;
                  if (totalWidth < constraints.maxWidth) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (String filter in filters)
                          ResultLabel(
                            label: filter,
                            index: resultFilterProviderState['matchType']
                                    ?[filter] ??
                                0,
                          ),
                      ],
                    );
                  } else {
                    // Scroll if overflowing
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (String filter in filters)
                            ResultLabel(
                              label: filter,
                              index: resultFilterProviderState['matchType']
                                      ?[filter] ??
                                  0,
                            ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            futureAsyncValue.when(
              data: (data) {
                return data.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 16,
                          ),
                          itemBuilder: (context, index) => CustomExpander(
                            selfSpaced: true,
                            body: Column(
                              spacing: 2,
                              children: [
                                for (MatchResult match in data[index].matches)
                                  ResultWidget(
                                    result: match,
                                    pool: data[index].resultName,
                                    showHeader: false,
                                  )
                              ],
                            ),
                            header: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                data[index].resultName,
                                style: TextStyle(
                                  color: colorThemeState.fontColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
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
                          "Der er ingen resultater tilgængelige",
                        ),
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
