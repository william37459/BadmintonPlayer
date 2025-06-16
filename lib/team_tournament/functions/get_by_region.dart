import 'dart:convert';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/classes/team_tournament_region.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<List<TeamTournamentRegion>> getByRegion(
    String contextKey, String ageGroupId, String regionId) async {
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
        "subPage": 1,
        "seasonID": "2024",
        "leagueGroupID": null,
        "ageGroupID": ageGroupId,
        "regionID": regionId,
        "leagueGroupTeamID": null,
        "leagueMatchID": null,
        "clubID": null,
        "playerID": null
      },
    ),
  );

  List<TeamTournamentRegion> results = [];

  if (response.statusCode == 200) {
    final document = html_parser.parse(json.decode(response.body)['d']['html']);

    List<Element>? rows = document.querySelector('tbody')?.children;
    String poolName = "";
    if (rows != null) {
      for (var row in rows) {
        if (row.className == "divisionrow") {
          poolName = row.text.trim();
        } else {
          results.add(
            TeamTournamentRegion(
              header: row.text,
              pool: poolName,
              filter: TeamTournamentFilter.fromString(
                row.querySelector("a")?.attributes['onclick'] ?? '{}',
                poolName,
              ),
            ),
          );
        }
      }
    }
  }
  return results;
}
