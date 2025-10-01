import 'dart:convert';

import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<List<TeamTournamentResultPreview>> getTeamTournamentResults(
  List<String> leagues,
  String contextKey,
  List<String>? matchIds,
) async {
  List<Future<List<TeamTournamentResultPreview>>> futures = leagues.map((
    league,
  ) async {
    List<TeamTournamentResultPreview> results = [];
    List<String> leagueAttributes = league.split(",");
    http.Response response = await http.post(
      Uri.parse(
        "https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetLeagueStanding",
      ),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: json.encode({
        "ageGroupID": leagueAttributes[3],
        "clubID": matchIds != null ? "" : leagueAttributes[8],
        "leagueGroupID": matchIds != null
            ? leagueAttributes[2]
            : leagueAttributes[5],
        "seasonID": leagueAttributes[1],
        "leagueGroupTeamID": "",
        "leagueMatchID": matchIds != null ? leagueAttributes[6] : "",
        "playerID": "",
        "regionID": matchIds != null ? leagueAttributes[4] : "",
        "callbackcontextkey": contextKey,
        "subPage": "4",
      }),
    );

    if (response.statusCode != 200) {
      return [] as List<TeamTournamentResultPreview>;
    }

    Map formattedResponse = json.decode(response.body);

    String htmlContent = formattedResponse['d']['html'];

    Document document = html_parser.parse(htmlContent);
    List<Element> allRows =
        document.querySelector(".matchlist")?.children[0].children ?? [];

    for (Element row in allRows) {
      if (!row.attributes.values.contains("headerrow") &&
          !row.attributes.values.contains("roundheader") &&
          results.length < 10) {
        String date = row.querySelector(".time")?.text ?? "";
        late DateTime dateTime;
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
        if (dateTime.isAfter(DateTime.now())) {
          continue; // Skip matches older than a year
        }
        results.add(
          TeamTournamentResultPreview.fromElement(
            row,
            document.querySelector("h3")?.text ??
                document.querySelector("h2")?.text ??
                "Kamp",
          ),
        );
      }
    }
    return results;
  }).toList();

  // Wait for all requests to complete
  List<TeamTournamentResultPreview> results = [
    for (List<TeamTournamentResultPreview> result in (await Future.wait(
      futures,
    )))
      ...result,
  ];

  Set<String> seenMatchNumbers = {};
  results = results.where((item) {
    if (seenMatchNumbers.contains(item.matchNumber)) {
      return false;
    } else {
      seenMatchNumbers.add(item.matchNumber);
      return true;
    }
  }).toList();

  if (matchIds != null) {
    results.retainWhere((element) => matchIds.contains(element.matchNumber));

    return results;
  } else {
    results.sort((a, b) => a.date.compareTo(b.date));

    return results.take(10).toList();
  }
}
