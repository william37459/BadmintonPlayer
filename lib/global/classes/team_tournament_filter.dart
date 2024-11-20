class TeamTournamentFilter {
  final String text;
  final String clubID;
  final String leagueGroupID;
  final String leagueGroupTeamID;
  final String leagueMatchID;
  final String ageGroupID;
  final String playerID;
  final String regionID;
  final String seasonID;
  final String subPage;

  TeamTournamentFilter({
    required this.text,
    required this.clubID,
    required this.leagueGroupID,
    required this.leagueGroupTeamID,
    required this.leagueMatchID,
    required this.ageGroupID,
    required this.playerID,
    required this.regionID,
    required this.seasonID,
    required this.subPage,
  });

  Map<String, String> toJson() {
    return {
      'clubID': clubID,
      'leagueGroupID': leagueGroupID,
      'leagueGroupTeamID': leagueGroupTeamID,
      'leagueMatchID': leagueMatchID,
      'ageGroupID': ageGroupID,
      'playerID': playerID,
      'regionID': regionID,
      'seasonID': seasonID,
      'subPage': subPage,
    };
  }

  factory TeamTournamentFilter.fromString(String data, String text) {
    List<String> params = data
        .replaceAll('return ShowStanding(', '')
        .replaceAll("'", "")
        .replaceAll(');', '')
        .split(', ');
    return TeamTournamentFilter(
      text: text,
      clubID: params[8],
      leagueGroupID: params[2],
      leagueGroupTeamID: params[5],
      leagueMatchID: params[6],
      ageGroupID: params[3],
      playerID: params[7],
      regionID: params[4],
      seasonID: params[1],
      subPage: params[0],
    );
  }
}

class TeamTournamentFilterClub extends TeamTournamentFilter {
  final String club;

  TeamTournamentFilterClub({
    required this.club,
    required super.text,
    required super.clubID,
    required super.leagueGroupID,
    required super.leagueGroupTeamID,
    required super.leagueMatchID,
    required super.ageGroupID,
    required super.playerID,
    required super.regionID,
    required super.seasonID,
    required super.subPage,
  });
}
