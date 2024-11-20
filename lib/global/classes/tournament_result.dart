import 'package:app/global/classes/profile.dart';

class TournamentResult {
  final String resultName;
  final List<MatchResult> matches;

  TournamentResult({
    required this.resultName,
    required this.matches,
  });

  factory TournamentResult.fromJson(Map<String, dynamic> json) {
    return TournamentResult(
      resultName: json['resultName'],
      matches: json['matches'],
    );
  }
}

class MatchResult {
  List<Profile> winner;
  List<Profile> loser;
  List<String> result;

  MatchResult({
    required this.winner,
    required this.loser,
    required this.result,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      winner: json['winner'],
      loser: json['loser'],
      result: json['result'],
    );
  }
}
