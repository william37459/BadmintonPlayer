import 'package:app/global/classes/team_tournament_club_result.dart';
import 'package:app/global/classes/team_tournament_filter.dart';

class AllTeamTournamentMatches {
  final List<TeamTournamentFilter> buttons;
  final Map<String, List<TeamTournamentResultTeam>> matches;

  AllTeamTournamentMatches({
    required this.buttons,
    required this.matches,
  });
}
