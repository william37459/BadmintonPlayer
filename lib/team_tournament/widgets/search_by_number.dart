import 'package:app/calendar/widgets/custom_input.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament/functions/get_latest_searches.dart';
import 'package:app/team_tournament/functions/search_match_number.dart';
import 'package:app/team_tournament/index.dart';
import 'package:app/team_tournament_results/match_result/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

TextEditingController searchController = TextEditingController();

class SearchByNumber extends ConsumerWidget {
  const SearchByNumber({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    List<InlineSpan> highlightedResult(
        String matchNumber, String searchString) {
      int index = matchNumber.indexOf(searchString);
      if (index == -1) {
        return [
          TextSpan(
            text: matchNumber,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ];
      }
      return [
        TextSpan(
          text: matchNumber.substring(0, index),
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        TextSpan(
          text: matchNumber.substring(index, index + searchString.length),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextSpan(
          text: matchNumber.substring(index + searchString.length),
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ];
    }

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xffEBEBEB),
                  borderRadius: BorderRadius.circular(48),
                ),
                child: CustomInput(
                  hint: "Søg efter kampnummer",
                  provider: teamTournamentFilterProvider,
                  providerKey: "matchNumber",
                  inputType: TextInputType.number,
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
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: colorThemeState.secondaryFontColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Søg",
                          style: TextStyle(
                            color: colorThemeState.secondaryFontColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        FutureBuilder(
            future: getLatestSearches(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      "Her vil dine seneste søgninger blive vist",
                    ),
                  ),
                );
              } else {
                return snapshot.data!.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text(
                            "Her vil dine seneste søgninger blive vist",
                          ),
                        ),
                      )
                    : Consumer(builder: (context, ref, child) {
                        final CustomColorTheme colorThemeState =
                            ref.watch(colorThemeProvider);
                        final teamTournamentFilter =
                            ref.watch(teamTournamentFilterProvider);
                        return Expanded(
                          child: ListView.separated(
                            itemCount: snapshot.data!.length,
                            separatorBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: Divider(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            itemBuilder: (context, index) {
                              LatestSearch search = snapshot.data![index];
                              return search.matchNumber.contains(
                                      teamTournamentFilter['matchNumber'] ?? "")
                                  ? InkWell(
                                      onTap: () {
                                        ref
                                            .read(
                                                leagueMatchIDProvider.notifier)
                                            .state = search.matchNumber;
                                        if (!context.mounted) return;
                                        Navigator.pushNamed(
                                          context,
                                          "/TeamTournamentResultPage",
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    "${search.homeTeam} -  ${search.awayTeam}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: "#",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 14,
                                                      ),
                                                      children:
                                                          highlightedResult(
                                                        search.matchNumber,
                                                        teamTournamentFilter[
                                                                'matchNumber'] ??
                                                            "",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: colorThemeState
                                                    .primaryColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        );
                      });
              }
            }),
      ],
    );
  }
}
