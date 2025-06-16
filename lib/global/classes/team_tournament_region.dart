import 'package:app/global/classes/team_tournament_filter.dart';

class TeamTournamentRegion {
  final String header;
  final String pool;
  final TeamTournamentFilter filter;

  TeamTournamentRegion({
    required this.header,
    required this.pool,
    required this.filter,
  });
}
