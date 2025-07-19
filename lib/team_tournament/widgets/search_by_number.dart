import 'package:app/calendar/widgets/custom_input.dart';
import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/dashboard/widgets/team_tournament_result_preview.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament/functions/get_latest_searches.dart';
import 'package:app/team_tournament/functions/search_match_number.dart';
import 'package:app/team_tournament/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

TextEditingController searchController = TextEditingController();

FutureProvider<List<TeamTournamentResultPreview>?> latestSearchesProvider =
    FutureProvider<List<TeamTournamentResultPreview>?>((ref) async {
  return getLatestSearches();
});

class SearchByNumber extends ConsumerWidget {
  const SearchByNumber({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 41,
                decoration: BoxDecoration(
                  color: const Color(0xffEBEBEB),
                  borderRadius: BorderRadius.circular(48),
                ),
                child: Center(
                  child: CustomInput(
                    hint: "Søg efter kampnummer",
                    provider: teamTournamentFilterProvider,
                    providerKey: "matchNumber",
                    inputType: TextInputType.number,
                    controller: searchController,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
              child: Material(
                color: colorThemeState.primaryColor,
                borderRadius: BorderRadius.circular(48),
                child: InkWell(
                  borderRadius: BorderRadius.circular(48),
                  onTap: () => searchMatchNumber(
                    ref.read(teamTournamentFilterProvider)['matchNumber'] ?? "",
                    ref,
                    context,
                    searchController,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: colorThemeState.secondaryFontColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Søg",
                          style: TextStyle(
                            color: colorThemeState.secondaryFontColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Consumer(
          builder: (context, ref, child) {
            final latestSearches = ref.watch(latestSearchesProvider);
            final teamTournamentFilter =
                ref.watch(teamTournamentFilterProvider);
            return latestSearches.when(
              data: (snapshot) {
                if (snapshot == null || snapshot.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "Her vil dine seneste søgninger blive vist",
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: snapshot.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        TeamTournamentResultPreview preview = snapshot[index];
                        return preview.matchNumber.contains(
                                teamTournamentFilter['matchNumber'] ?? "")
                            ? TeamTournamentResultPreviewWidget(
                                result: preview,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                              )
                            : Container();
                      },
                    ),
                  );
                }
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
              error: (error, stack) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      "Her vil dine seneste søgninger blive vist",
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
