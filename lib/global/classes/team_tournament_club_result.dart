import 'package:app/global/classes/team_tournament_filter.dart';

class TeamTournamentResults {
  final List<TeamTournamentFilter> buttons;
  final List<TeamTournamentResultTeam> teams;

  TeamTournamentResults({
    required this.buttons,
    required this.teams,
  });
}

class TeamTournamentResultTeam {
  final String time;
  final TeamTournamentFilter matchNumber;
  final TeamTournamentFilter homeTeam;
  final TeamTournamentFilter awayTeam;
  final String arranger;
  final String place;
  final String result;
  final String points;

  TeamTournamentResultTeam({
    required this.time,
    required this.matchNumber,
    required this.homeTeam,
    required this.awayTeam,
    required this.arranger,
    required this.place,
    required this.result,
    required this.points,
  });
}
