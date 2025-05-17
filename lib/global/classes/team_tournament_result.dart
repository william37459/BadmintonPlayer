import 'package:app/global/classes/tournament_result.dart';

class TeamTournamentResult {
  final Map<String, List<String>> info;
  final String result;
  final String points;
  final String homeTeam;
  final String awayTeam;
  final List<TournamentResult> matches;

  TeamTournamentResult({
    required this.info,
    required this.result,
    required this.points,
    required this.homeTeam,
    required this.awayTeam,
    required this.matches,
  });
}
