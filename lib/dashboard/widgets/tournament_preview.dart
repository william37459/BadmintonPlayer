import 'package:app/global/classes/settings.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/tournament.dart';
import 'package:app/global/constants.dart';
import 'package:app/settings/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TournamentPreviewWidget extends ConsumerWidget {
  final Tournament tournament;
  final double? width;
  const TournamentPreviewWidget({
    super.key,
    required this.tournament,
    this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    Settings settingsState = ref.watch(settingsProvider);
    List<int> favouriteTournamentsState =
        (ref.watch(favouriteTournaments) ?? [])
            .map((e) => int.tryParse(e.split("_")[2]) ?? -2)
            .toList();

    String formatter = settingsState.naturaltime ? 'dd MMM' : 'dd/MM';

    return CustomContainer(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(selectedTournament.notifier).state =
                tournament.tournamentClassID;
            Navigator.of(context).pushNamed(
              "/TournamentParticipationPage",
              arguments: {"tournament": tournament},
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          if (settingsState.starAtFavourites &&
                              (favouriteTournamentsState.contains(
                                    tournament.tournamentID,
                                  ) ||
                                  tournament.tournamentID == -1))
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Icon(
                                Icons.star,
                                color: colorThemeState.primaryColor,
                                size: 24,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              tournament.clubName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        tournament.getFormattedClassAndAgeGroupCodes().join(
                          ',\t',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.8,
                          ),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${DateFormat(formatter, 'da_dk').format(tournament.dateFrom)} - ${DateFormat(formatter, 'da_dk').format(tournament.dateTo)}',
                        style: TextStyle(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.8,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.info_outline,
                  color: colorThemeState.fontColor.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
