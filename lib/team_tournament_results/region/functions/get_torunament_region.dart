import 'dart:convert';

import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<Map<String, List<TeamTournamentFilter>>> getTeamTournamentRegion(
    String contextKey, Map<String, String> filter) async {
  http.Response response = await http.post(
    Uri.parse(
      "https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetLeagueStanding",
    ),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
    body: json.encode(
      {
        "callbackcontextkey": contextKey,
        ...filter,
      },
    ),
  );

  Map<String, List<TeamTournamentFilter>> result = {};

  if (response.statusCode == 200) {
    final document = html_parser.parse(json.decode(response.body)['d']['html']);

    List<Element> rows = document.querySelectorAll('tr');
    List<TeamTournamentFilter> allTeamTournamentFilters = [];

    String header = "";

    for (Element row in rows) {
      if (row.className == "divisionrow") {
        if (header.isNotEmpty) {
          result.putIfAbsent(header, () => allTeamTournamentFilters);
          allTeamTournamentFilters = [];
        }
        header = row.text;
      } else if (row.className == "grouprow") {
        List<String> params =
            (row.querySelector('a')?.attributes['onclick'] ?? '')
                .replaceAll('return ShowStanding(', '')
                .replaceAll("'", "")
                .replaceAll(');', '')
                .split(', ');

        params.map((param) => "'$param'").toList();

        allTeamTournamentFilters.add(
          TeamTournamentFilter(
            text: row.text,
            clubID: params[8],
            leagueGroupID: params[2],
            leagueGroupTeamID: params[5],
            leagueMatchID: params[6],
            ageGroupID: params[3],
            playerID: params[7],
            regionID: params[4],
            seasonID: params[1],
            subPage: params[0],
          ),
        );
      }
    }
  }

  return result;
}
