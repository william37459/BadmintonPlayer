import 'package:html/dom.dart';

class TeamTournamentResultPreview {
  final DateTime date;
  final TeamTournamentTeamPreview homeTeam;
  final TeamTournamentTeamPreview awayTeam;
  final String organizer;
  final String location;
  final String league;
  final String matchNumber;

  TeamTournamentResultPreview({
    required this.date,
    required this.matchNumber,
    required this.homeTeam,
    required this.awayTeam,
    required this.organizer,
    required this.location,
    required this.league,
  });

  factory TeamTournamentResultPreview.fromElement(
      Element element, String league) {
    String date = element.querySelector(".time")?.text ?? "";
    DateTime dateTime = DateTime.parse(
      "${date.split(" ")[1].split("‑").reversed.join("-")} ${date.split(" ")[2]}:00",
    );
    //2012-02-27 13:27:00
    String matchNumber = element.querySelector(".matchno")?.text ?? "";
    String homeTeam = element.querySelectorAll("td.team")[0].text;
    String awayTeam = element.querySelectorAll("td.team")[1].text;
    String organizer = element.querySelectorAll("td.team")[2].text;
    String location = element.querySelector(".venue")?.text ?? "";
    String result = element.querySelector(".score")?.text ?? "";
    String point = element.querySelector(".points")?.text ?? "";

    return TeamTournamentResultPreview(
      date: dateTime,
      matchNumber: matchNumber,
      homeTeam: TeamTournamentTeamPreview.fromStringList([
        homeTeam,
        result.split("-")[0],
        point.split("-")[0],
      ]),
      awayTeam: TeamTournamentTeamPreview.fromStringList([
        awayTeam,
        result.split("-")[1],
        point.split("-")[1],
      ]),
      organizer: organizer,
      location: location,
      league: league,
    );
  }
}

class TeamTournamentTeamPreview {
  String name;
  int result;
  int point;

  TeamTournamentTeamPreview({
    required this.name,
    required this.result,
    required this.point,
  });

  factory TeamTournamentTeamPreview.fromStringList(List<String> list) {
    {
      return TeamTournamentTeamPreview(
        name: list[0],
        result: int.tryParse(list[1]) ?? 0,
        point: int.tryParse(list[2]) ?? 0,
      );
    }
  }
}
