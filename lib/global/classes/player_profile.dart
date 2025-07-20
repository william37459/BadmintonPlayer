import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/dashboard/classes/tournament_result_preview.dart';

class PlayerProfile {
  final String name;
  final String id;
  final List<AttachedProfile> attachedProfiles;
  final String club;
  final String startLevel;
  final List<ScoreData> scoreData;
  final List<TeamTournamentResultPreview> teamTournaments;
  final List<TournamentResultPreview> tournaments;
  final Map<String, String> seasons;

  PlayerProfile({
    required this.name,
    required this.attachedProfiles,
    required this.club,
    required this.startLevel,
    required this.scoreData,
    required this.teamTournaments,
    required this.tournaments,
    required this.seasons,
    required this.id,
  });
}

class AttachedProfile {
  final String name;
  final String id;

  AttachedProfile({required this.name, required this.id});
}

class ScoreData {
  final String type;
  final String rank;
  String points;
  final String matches;
  String placement;

  ScoreData({
    required this.type,
    required this.rank,
    required this.points,
    required this.matches,
    required this.placement,
  });

  factory ScoreData.empty() {
    return ScoreData(
      type: "",
      rank: "",
      points: "",
      matches: "",
      placement: "",
    );
  }
}

class TeamTournament {
  final DateTime date;
  final String rank;
  final String team;
  final String opponent;

  TeamTournament({
    required this.date,
    required this.rank,
    required this.team,
    required this.opponent,
  });
}
