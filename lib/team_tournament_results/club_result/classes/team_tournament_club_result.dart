import 'package:html/dom.dart';

class TeamTournamentClubResult {
  int placement;
  String clubName;
  int matches;
  int won;
  Score score;
  Sets sets;
  int points;
  int sPoints;
  int leagueGroupId;
  int leagueTeamId;

  TeamTournamentClubResult({
    required this.placement,
    required this.clubName,
    required this.matches,
    required this.won,
    required this.score,
    required this.sets,
    required this.points,
    required this.sPoints,
    required this.leagueGroupId,
    required this.leagueTeamId,
  });

  factory TeamTournamentClubResult.fromElement(Element element) {
    int placement =
        int.tryParse(element.querySelector(".standing")?.text ?? "") ?? -1;
    String clubName =
        element.querySelector(".team1")?.text.trim() ?? "Ikke oplyst";
    List<String> allScores = element
        .querySelectorAll(".score")
        .map((e) => e.text)
        .toList();
    int matches = int.tryParse(allScores.elementAtOrNull(0) ?? "") ?? -1;
    int won = int.tryParse(allScores.elementAtOrNull(1) ?? "") ?? -1;
    int points = int.tryParse(allScores.elementAtOrNull(4) ?? "") ?? -1;
    int sPoints = int.tryParse(allScores.elementAtOrNull(5) ?? "") ?? -1;

    List<String> hrefParts =
        element
            .querySelector(".team1 > a")
            ?.attributes['onclick']
            ?.split(", ")
            .map((e) => e.replaceAll("'", ""))
            .toList() ??
        [];
    int leagueGroupId = int.tryParse(hrefParts.elementAtOrNull(2) ?? "") ?? -1;
    int leagueTeamId = int.tryParse(hrefParts.elementAtOrNull(5) ?? "") ?? -1;

    return TeamTournamentClubResult(
      placement: placement,
      clubName: clubName,
      matches: matches,
      won: won,
      score: Score.fromString(allScores.elementAtOrNull(2) ?? ""),
      sets: Sets.fromString(allScores.elementAtOrNull(3) ?? ""),
      points: points,
      sPoints: sPoints,
      leagueGroupId: leagueGroupId,
      leagueTeamId: leagueTeamId,
    );
  }
}

class Sets {
  int own;
  int against;

  Sets({required this.own, required this.against});

  factory Sets.fromString(String text) {
    return Sets(
      own: int.tryParse(text.split("-").elementAtOrNull(0) ?? "??") ?? -1,
      against: int.tryParse(text.split("-").elementAtOrNull(1) ?? "??") ?? -1,
    );
  }

  @override
  String toString() => '$own-$against';
}

class Score {
  int own;
  int against;

  Score({required this.own, required this.against});

  factory Score.fromString(String text) {
    return Score(
      own: int.tryParse(text.split("-").elementAtOrNull(0) ?? "??") ?? -1,
      against: int.tryParse(text.split("-").elementAtOrNull(1) ?? "??") ?? -1,
    );
  }
  @override
  String toString() => '$own-$against';
}
