import 'package:app/global/classes/team_tournament_filter.dart';

class TeamTournamentPosition {
  final List<TeamTournamentFilter> buttons;
  final List<TeamTournamentPositionTeam> teams;

  TeamTournamentPosition({
    required this.teams,
    required this.buttons,
  });
}

class TeamTournamentPositionTeam {
  final String position;
  final String name;
  final String matches;
  final String wins;
  final String score;
  final String sets;
  final String points;
  final TeamTournamentFilter filter;

  TeamTournamentPositionTeam({
    required this.position,
    required this.name,
    required this.matches,
    required this.wins,
    required this.score,
    required this.sets,
    required this.points,
    required this.filter,
  });
}
