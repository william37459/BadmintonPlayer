import 'package:app/global/classes/team_tournament_filter.dart';

class TeamTournamentClub {
  final String ageGroup;
  final String teamName;
  final String poolName;
  final TeamTournamentFilter filter;

  TeamTournamentClub({
    required this.ageGroup,
    required this.teamName,
    required this.poolName,
    required this.filter,
  });
}
