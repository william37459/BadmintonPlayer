import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/participant.dart';
import 'package:app/global/classes/tournament.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/calendar/widgets/custom_expander.dart';
import 'package:app/calendar/widgets/drop_down_selector.dart';
import 'package:app/tournament_participation_list/functions/get_participaters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Map<String, dynamic>> tournamentParticipationFilterProvider =
    StateProvider<Map<String, dynamic>>(
  (ref) => {
    "clientselectfunction": "SelectTournamentClass1",
    "clubid": 0,
    "groupnumber": 0,
    "locationnumber": 0,
    "playerid": 0,
    "tabnumber": 0,
    "tournamentclassid": null,
    "tournamenteventid": 0,
  },
);

StateProvider<Map<String, String>> rankFilterProvider = StateProvider(
  (ref) => {},
);

FutureProvider<List<Participant>> tournamentParticipationProvider =
    FutureProvider<List<Participant>>((ref) async {
  final filterProvider = ref.watch(tournamentParticipationFilterProvider);
  final selectedTournamentState = ref.watch(selectedTournament);

  final result = await getParticipaters(
    filterProvider,
    contextKey,
    filterProvider['tournamentclassid'] ?? selectedTournamentState,
  );

  ref.read(rankFilterProvider.notifier).state = result['filters'];

  return result['data'];
});

class TournamentParticipationList extends ConsumerWidget {
  final Tournament tournament;

  const TournamentParticipationList({super.key, required this.tournament});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    AsyncValue<List<Participant>> futureAsyncValue =
        ref.watch(tournamentParticipationProvider);
    Map<String, String> rankFilterProviderState = ref.watch(rankFilterProvider);

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
                        tournament.title != null && tournament.title!.isNotEmpty
                            ? tournament.title!
                            : tournament.clubName,
                        style: TextStyle(
                          color: colorThemeState.secondaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomContainer(
              child: Row(
                children: [
                  Expanded(
                    child: CustomDropDownSelector(
                      data: rankFilterProviderState,
                      provider: tournamentParticipationFilterProvider,
                      providerKey: "tournamentclassid",
                      hint: "Vælg række",
                    ),
                  ),
                ],
              ),
            ),
            futureAsyncValue.when(
              data: (data) {
                List<String> categoryList = [];
                for (var element in data) {
                  if (!categoryList.contains(element.category)) {
                    categoryList.add(element.category);
                  }
                }

                return Expanded(
                  child: ListView(
                    children: [
                      for (String category in categoryList)
                        CustomExpander(
                          isExpanded: true,
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (Participant participant in data)
                                if (participant.category == category)
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(
                                      8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          participant.players
                                              .where((customClass) =>
                                                  customClass.name.isNotEmpty)
                                              .map((customClass) =>
                                                  customClass.name)
                                              .join(' & '),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: colorThemeState.fontColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Fra: ${participant.players.where((customClass) => customClass.club.isNotEmpty).map((customClass) => customClass.club).join(' & ')}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: colorThemeState.fontColor
                                                .withValues(alpha: 0.5),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "Tilmeldt af: ${participant.registrator}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: colorThemeState.fontColor
                                                .withValues(alpha: 0.5),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                          header: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: colorThemeState.secondaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          isExpandedKey: category,
                        ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
              loading: () => const Expanded(
                child: Center(
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
