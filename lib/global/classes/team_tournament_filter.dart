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

  factory TeamTournamentFilter.fromJson(Map<String, dynamic> data) {
    return TeamTournamentFilter(
      text: "",
      clubID: data['clubID'],
      leagueGroupID: data['leagueGroupID'],
      leagueGroupTeamID: data['leagueGroupTeamID'],
      leagueMatchID: data['leagueMatchID'],
      ageGroupID: data['ageGroupID'],
      playerID: data['playerID'],
      regionID: data['regionID'],
      seasonID: data['seasonID'],
      subPage: data['subPage'],
    );
  }

  factory TeamTournamentFilter.fromString(String data, String text) {
    List<String> params = data
        .replaceAll('return ShowStanding(', '')
        .replaceAll("'", "")
        .replaceAll(');', '')
        .split(',')
        .map((e) => e.trim())
        .toList();
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

  TeamTournamentFilter copyWith({
    String? text,
    String? clubID,
    String? leagueGroupID,
    String? leagueGroupTeamID,
    String? leagueMatchID,
    String? ageGroupID,
    String? playerID,
    String? regionID,
    String? seasonID,
    String? subPage,
  }) {
    return TeamTournamentFilter(
      text: text ?? this.text,
      clubID: clubID ?? this.clubID,
      leagueGroupID: leagueGroupID ?? this.leagueGroupID,
      leagueGroupTeamID: leagueGroupTeamID ?? this.leagueGroupTeamID,
      leagueMatchID: leagueMatchID ?? this.leagueMatchID,
      ageGroupID: ageGroupID ?? this.ageGroupID,
      playerID: playerID ?? this.playerID,
      regionID: regionID ?? this.regionID,
      seasonID: seasonID ?? this.seasonID,
      subPage: subPage ?? this.subPage,
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

  //Function to return all values split by comma
  String get allValues =>
      "$subPage,$seasonID,$leagueGroupID,$ageGroupID,$regionID,$leagueGroupTeamID,$leagueMatchID,$clubID,$playerID";
}
