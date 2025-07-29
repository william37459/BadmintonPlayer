import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/tournament.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TournamentWidget extends ConsumerWidget {
  final Tournament tournament;
  const TournamentWidget({super.key, required this.tournament});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.5), blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tournament.title != null && tournament.title!.isNotEmpty
                ? tournament.title!
                : tournament.clubName,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                tournament.lastRegistration != null
                    ? "Tilmeldingsfrist: ${DateFormat('EEE, M/d/y').format(tournament.lastRegistration!)}"
                    : "Ingen tilmeldingsfrist",
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            children: [
              for (
                int index = 0;
                index < tournament.getClassAndAgeGroupCodes().length;
                index++
              )
                Text(
                  tournament.getClassAndAgeGroupCodes()[index] +
                      (index == tournament.getClassAndAgeGroupCodes().length - 1
                          ? ""
                          : ", "),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                size: 12,
                color: Colors.black.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('d. MMMM').format(tournament.dateFrom),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          Icon(
            Icons.more_vert,
            size: 12,
            color: Colors.black.withValues(alpha: 0.5),
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                size: 12,
                color: Colors.black.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('d. MMMM').format(tournament.dateTo),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (tournament.participatersReady())
                Expanded(
                  child: Material(
                    color: colorThemeState.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        ref.read(selectedTournament.notifier).state = tournament
                            .tournamentClassID
                            .toString();
                        Navigator.of(context).pushNamed(
                          "/TournamentParticipationPage",
                          arguments: {"tournament": tournament},
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          "Deltagerliste",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorThemeState.secondaryFontColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (tournament.resultsReady() & tournament.participatersReady())
                const SizedBox(width: 12),
              if (tournament.resultsReady())
                Expanded(
                  child: Material(
                    color: colorThemeState.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        ref.read(selectedTournament.notifier).state = tournament
                            .tournamentClassID
                            .toString();
                        Navigator.of(context).pushNamed(
                          "/TournamentResultPage",
                          arguments: {
                            "tournament":
                                tournament.title != null &&
                                    tournament.title!.isNotEmpty
                                ? tournament.title
                                : tournament.clubName,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          "Resultater",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorThemeState.secondaryFontColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
