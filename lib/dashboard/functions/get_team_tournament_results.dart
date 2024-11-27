import 'dart:convert';

import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<List<TeamTournamentResultPreview>> getTeamTournamentResults(
  List<String> matches,
  String contextKey,
) async {
  List<TeamTournamentResultPreview> results = [];

  for (String match in matches) {
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
        "clubID": formattedMatch[8],
        "leagueGroupID": formattedMatch[5],
        "seasonID": formattedMatch[1],
        "leagueGroupTeamID": "",
        "leagueMatchID": "",
        "playerID": "",
        "regionID": "",
        "callbackcontextkey": contextKey,
        "subPage": "4",
      }),
    );

    if (response.statusCode != 200) {
      continue;
    }

    Map formattedResponse = json.decode(response.body);

    String htmlContent = formattedResponse['d']['html'];

    Document document = html_parser.parse(htmlContent);
    List<Element> allRows =
        document.querySelector(".matchlist")?.children[0].children ?? [];

    for (Element row in allRows) {
      if (!row.attributes.values.contains("headerrow") &&
          !row.attributes.values.contains("roundheader")) {
        results.add(
          TeamTournamentResultPreview.fromElement(
            row,
            document.querySelector("h2")?.text ?? "Kamp",
          ),
        );
      }
    }
  }

  Set<String> seenMatchNumbers = {};
  results = results.where((item) {
    if (seenMatchNumbers.contains(item.matchNumber)) {
      return false;
    } else {
      seenMatchNumbers.add(item.matchNumber);
      return true;
    }
  }).toList();

  results.sort((a, b) => a.date.compareTo(b.date));

  return results.sublist(0, 10);
}
