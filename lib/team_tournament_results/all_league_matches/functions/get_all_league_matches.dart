import 'dart:convert';

import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/global/constants.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

Future<List<TeamTournamentResultPreview>> getAllLeagueMatches(
  int leagueGroupId,
  int leagueGroupTeamId,
) async {
  await Future.delayed(const Duration(seconds: 2));
  http.Response response = await http.post(
    Uri.parse(
      "https://www.badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetLeagueStanding",
    ),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: json.encode({
      "callbackcontextkey": contextKey,
      "subPage": "3",
      "seasonID": season,
      "leagueGroupID": leagueGroupId.toString(),
      "ageGroupID": "",
      "regionID": "",
      "leagueGroupTeamID": leagueGroupTeamId.toString(),
      "leagueMatchID": "",
      "clubID": "",
      "playerID": "",
    }),
  );
  List<TeamTournamentResultPreview> results = [];
  if (response.statusCode == 200) {
    Document table = html_parser.parse(
      json.decode(response.body)['d']['html'] as String,
    );
    List<Element> rows = table.querySelectorAll('tbody > tr');
    String league = table.querySelector("h3")?.text.trim() ?? "Ukendt";
    for (Element row in rows) {
      if (row.classes.contains('headerrow')) {
        continue;
      }
      results.add(TeamTournamentResultPreview.fromElement(row, league));
    }
  }
  return results;
}
