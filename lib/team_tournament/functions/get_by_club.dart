import 'dart:convert';

import 'package:app/global/classes/team_tournament_club.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<List<TeamTournamentClub>> getByClub(
  String contextKey,
  String clubId,
) async {
  http.Response response = await http.post(
    Uri.parse(
      "https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetLeagueStanding",
    ),
    headers: {"Content-Type": "application/json; charset=utf-8"},
    body: json.encode({
      "callbackcontextkey": contextKey,
      "subPage": 6,
      "seasonID": season,
      "leagueGroupID": null,
      "ageGroupID": null,
      "regionID": null,
      "leagueGroupTeamID": null,
      "leagueMatchID": null,
      "clubID": clubId,
      "playerID": null,
    }),
  );

  List<TeamTournamentClub> results = [];

  if (response.statusCode == 200) {
    final data = json.decode(response.body)['d']['html'];
    final document = html_parser.parse(data);

    List<Element>? rows = document.querySelector('tbody')?.children;
    String ageGroup = "";
    if (rows != null) {
      for (var row in rows) {
        if (row.className == "agegrouprow") {
          ageGroup = row.text.trim();
        } else {
          results.add(
            TeamTournamentClub(
              ageGroup: ageGroup,
              teamName:
                  row.querySelectorAll("td").firstOrNull?.text.trim() ?? "",
              poolName:
                  row.querySelectorAll("td").lastOrNull?.text.trim() ?? "",
              filter: TeamTournamentFilter.fromString(
                row.querySelector("a")?.attributes["onclick"] ?? '{}',
                ageGroup,
              ),
            ),
          );
        }
      }
    }
  }
  return results;
}
