import 'package:html/dom.dart';
import 'package:html/dom.dart' as html;

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
    Element element,
    String league,
  ) {
    String matchNumber = element.querySelector(".matchno")?.text ?? "";
    String homeTeam = element.querySelectorAll("td.team")[0].text;
    String awayTeam = element.querySelectorAll("td.team")[1].text;
    String organizer = element.querySelectorAll("td.team")[2].text;
    String location = element.querySelector(".venue")?.text ?? "";
    String result = element.querySelector(".score")?.text ?? "";
    String point = element.querySelector(".points")?.text ?? "";

    late DateTime dateTime;
    String date = element.querySelector(".time")?.text ?? "";
    if (date.split(" ").length < 3) {
      dateTime = DateTime.parse(
        date
            .replaceAll("(", "")
            .replaceAll(")", "")
            .split("‑")
            .reversed
            .join("-"),
      );
    } else {
      dateTime = DateTime.parse(
        "${date.split(" ")[1].split("‑").reversed.join("-")} ${date.split(" ")[2]}:00",
      );
    }

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

  factory TeamTournamentResultPreview.fromDocument(Document document) {
    List<html.Element> matchElement = document.querySelectorAll(
      'table.matchinfo tr',
    );
    String matchNumber =
        matchElement.elementAtOrNull(0)?.querySelector('td.val')?.text ?? "";
    String timeText =
        matchElement.elementAtOrNull(2)?.querySelector('td.val')?.text ?? "";
    String location =
        matchElement
            .elementAtOrNull(3)
            ?.querySelector('td.val')
            ?.innerHtml
            .replaceAll("<br>", "\n")
            .split('\n')
            .first ??
        "";
    String homeTeamName =
        matchElement.elementAtOrNull(4)?.querySelector('td.val a')?.text ?? "";
    String awayTeamName =
        matchElement.elementAtOrNull(5)?.querySelector('td.val a')?.text ?? "";
    String result =
        matchElement.elementAtOrNull(6)?.querySelector('td.val')?.text ?? "0-0";
    String points =
        matchElement.elementAtOrNull(7)?.querySelector('td.val')?.text ?? "0-0";
    String league = document.querySelector('h3')?.text ?? "";

    DateTime dateTime = DateTime.now();
    if (timeText.isNotEmpty) {
      try {
        List<String> parts = timeText.split(' ');
        if (parts.length >= 3) {
          String datePart = parts[1];
          String timePart = parts[2];

          List<String> dateParts = datePart.split('-');
          if (dateParts.length == 3) {
            String day = dateParts[0];
            String month = dateParts[1];
            String year = dateParts[2];

            dateTime = DateTime.parse("$year-$month-$day $timePart:00");
          }
        }
      } catch (e) {
        dateTime = DateTime.now();
      }
    }

    return TeamTournamentResultPreview(
      date: dateTime,
      matchNumber: matchNumber,
      homeTeam: TeamTournamentTeamPreview.fromStringList([
        homeTeamName,
        result.split("-")[0],
        points.split("-")[0],
      ]),
      awayTeam: TeamTournamentTeamPreview.fromStringList([
        awayTeamName,
        result.split("-")[1],
        points.split("-")[1],
      ]),
      organizer: "", // Not clearly available in this HTML structure
      location: location,
      league: league,
    );
  }

  factory TeamTournamentResultPreview.fromJson(Map<String, dynamic> json) {
    return TeamTournamentResultPreview(
      date: DateTime.parse(json['date']),
      matchNumber: json['matchNumber'],
      homeTeam: TeamTournamentTeamPreview.fromJson(json['homeTeam']),
      awayTeam: TeamTournamentTeamPreview.fromJson(json['awayTeam']),
      organizer: json['organizer'],
      location: json['location'],
      league: json['league'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'matchNumber': matchNumber,
      'homeTeam': homeTeam.toJson(),
      'awayTeam': awayTeam.toJson(),
      'organizer': organizer,
      'location': location,
      'league': league,
    };
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

  factory TeamTournamentTeamPreview.fromJson(Map<String, dynamic> json) {
    return TeamTournamentTeamPreview(
      name: json['name'],
      result: json['result'],
      point: json['point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'result': result, 'point': point};
  }
}
