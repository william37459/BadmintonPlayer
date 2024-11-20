import 'dart:convert';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/classes/team_tournament_position.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<TeamTournamentPosition> getTeamTournamentPositions(
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

  final List<TeamTournamentPositionTeam> teams = [];
  final List<TeamTournamentFilter> buttons = [];

  if (response.statusCode == 200) {
    final document = html_parser.parse(json.decode(response.body)['d']['html']);

    List<Element> rows = document.querySelector('body')?.children ?? [];

    for (int index = 0; index < rows.length; index++) {
      if (rows[index].attributes['href'] != null &&
          rows[index].attributes['href'] == "#") {
        String allFilters = rows[index].attributes['onclick'] ?? "";
        buttons.add(
          TeamTournamentFilter.fromString(allFilters, rows[index].text),
        );
      }
    }
    rows =
        document.querySelector('.groupstandings')?.children[0].children ?? [];

    if (rows.isNotEmpty) {
      rows.removeAt(0);
    }

    for (Element row in rows) {
      teams.add(
        TeamTournamentPositionTeam(
          position: row.children[0].text,
          name: row.children[1].text,
          matches: row.children[2].text,
          wins: row.children[3].text,
          score: row.children[4].text,
          sets: row.children[5].text,
          points: row.children[6].text,
          filter: TeamTournamentFilter.fromString(
            row.children[1].querySelector('a')?.attributes['onclick'] ?? "",
            row.children[1].text,
          ),
        ),
      );
    }
  }
  return TeamTournamentPosition(
    teams: teams,
    buttons: buttons,
  );
}
