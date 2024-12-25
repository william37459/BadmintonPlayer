import 'dart:convert';

import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/global/constants.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<TeamTournamentResultPreview?> getTeamTournamentResults(
  String match,
) async {
  List<String> formattedMatch = match.split(",");

  http.Response response = await http.post(
    Uri.parse(
      "https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetLeagueStanding",
    ),
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: json.encode({
      "ageGroupID": formattedMatch[3],
      "clubID": "",
      "leagueGroupID": formattedMatch[2],
      "seasonID": formattedMatch[1],
      "leagueGroupTeamID": "",
      "leagueMatchID": formattedMatch[6],
      "playerID": null,
      "regionID": formattedMatch[4],
      "callbackcontextkey": contextKey,
      "subPage": "5",
    }),
  );

  if (response.statusCode != 200) {
    return null;
  }

  Map formattedResponse = json.decode(response.body);

  String htmlContent = formattedResponse['d']['html'];

  Document document = html_parser.parse(htmlContent);

  List<Element> rows =
      document.querySelector(".matchinfo")?.children[0].children ?? [];

  TeamTournamentTeamPreview homeTeam = TeamTournamentTeamPreview(
    name: rows
            .firstWhere((e) => e.text.toLowerCase().contains("hjemmehold"))
            .querySelector("a")
            ?.text ??
        "",
    point: int.tryParse(rows
                .firstWhere((e) => e.text.toLowerCase().contains("point"))
                .querySelector(".val")
                ?.text
                .split("-")[0] ??
            "") ??
        0,
    result: int.tryParse(rows
                .firstWhere((e) => e.text.toLowerCase().contains("resultat"))
                .querySelector(".val")
                ?.text
                .split("-")[0] ??
            "") ??
        0,
  );

  TeamTournamentTeamPreview awayTeam = TeamTournamentTeamPreview(
    name: rows
            .firstWhere((e) => e.text.toLowerCase().contains("udehold"))
            .querySelector("a")
            ?.text ??
        "",
    point: int.tryParse(rows
                .firstWhere((e) => e.text.toLowerCase().contains("point"))
                .querySelector(".val")
                ?.text
                .split("-")[1] ??
            "") ??
        0,
    result: int.tryParse(rows
                .firstWhere((e) => e.text.toLowerCase().contains("resultat"))
                .querySelector(".val")
                ?.text
                .split("-")[1] ??
            "") ??
        0,
  );

  String date = rows
          .firstWhere((e) => e.text.toLowerCase().contains("tid"))
          .querySelector(".val")
          ?.text ??
      "";

  DateTime dateTime = DateTime.parse(
    "${date.split(" ")[1].split("-").reversed.join("-")} ${date.split(" ")[2]}:00",
  );

  return TeamTournamentResultPreview(
    date: dateTime,
    matchNumber: rows
            .firstWhere((e) => e.text.toLowerCase().contains("kampnr"))
            .querySelector(".val")
            ?.text ??
        "",
    homeTeam: homeTeam,
    awayTeam: awayTeam,
    organizer: "",
    location: "",
    league: document.querySelector("h2")?.text ?? "",
  );
}
