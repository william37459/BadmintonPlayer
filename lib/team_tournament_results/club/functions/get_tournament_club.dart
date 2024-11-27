import 'dart:convert';

import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<Map<String, List<TeamTournamentFilterClub>>> getTeamTournamentClub(
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

  Map<String, List<TeamTournamentFilterClub>> result = {};

  if (response.statusCode == 200) {
    final document = html_parser.parse(json.decode(response.body)['d']['html']);

    List<Element> rows = document.querySelectorAll('tr');
    List<TeamTournamentFilterClub> allTeamTournamentFilters = [];

    String header = "";

    for (Element row in rows) {
      if (row.className == "agegrouprow") {
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

        if (row.children.length > 1) {
          allTeamTournamentFilters.add(
            TeamTournamentFilterClub(
              club: row.children[0].text,
              text: row.children[1].text,
              clubID: params[8],
              leagueGroupID: params[5],
              leagueGroupTeamID: params[2],
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
    result.putIfAbsent(header, () => allTeamTournamentFilters);
  }

  return result;
}
