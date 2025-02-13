import 'package:app/global/classes/tournament_result.dart';
import 'package:flutter/material.dart';

class TournamentInfoDialog extends StatelessWidget {
  final TournamentInfo tournamentInfo;
  const TournamentInfoDialog({
    super.key,
    required this.tournamentInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Turneringsnummer"),
            Text(tournamentInfo.tournamentNumber),
            const Text("Dato"),
            Text(tournamentInfo.tournamentNumber),
            const Text("Kontakt"),
            Text(tournamentInfo.tournamentNumber),
            const Text("Senest opdateret"),
            Text(tournamentInfo.tournamentNumber),
          ],
        ),
      ),
    );
  }
}
