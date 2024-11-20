class TeamTournamentResult {
  final Map<String, List<String>> info;
  final String result;
  final String points;
  final String homeTeam;
  final String awayTeam;
  final List<TeamTournamentMatch> matches;

  TeamTournamentResult({
    required this.info,
    required this.result,
    required this.points,
    required this.homeTeam,
    required this.awayTeam,
    required this.matches,
  });
}

class TeamTournamentMatch {
  final String type;
  final List<TeamTournamentTeam> teams;

  TeamTournamentMatch({
    required this.type,
    required this.teams,
  });
}

class TeamTournamentTeam {
  final bool winner;
  final List<TeamTournamentPlayer> players;
  final List<String> points;

  TeamTournamentTeam({
    required this.winner,
    required this.players,
    required this.points,
  });
}

class TeamTournamentPlayer {
  final String name;
  final String id;

  TeamTournamentPlayer({
    required this.name,
    required this.id,
  });
}
