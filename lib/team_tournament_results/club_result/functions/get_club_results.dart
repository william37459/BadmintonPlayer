import 'dart:convert';

import 'package:app/global/constants.dart';
import 'package:app/team_tournament_results/club_result/classes/team_tournament_club_result.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

Future<List<TeamTournamentClubResult>> getClubResults(int leagueGroupId) async {
  http.Response response = await http.post(
    Uri.parse(
      "https://www.badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetLeagueStanding",
    ),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: json.encode({
      "callbackcontextkey": contextKey,
      "subPage": "2",
      "seasonID": season,
      "leagueGroupID": leagueGroupId,
      "ageGroupID": "",
      "regionID": "",
      "leagueGroupTeamID": "",
      "leagueMatchID": "",
      "clubID": "",
      "playerID": "",
    }),
  );

  List<TeamTournamentClubResult> results = [];

  if (response.statusCode == 200) {
    Document document = Document.html(json.decode(response.body)['d']['html']);
    List<Element> rows = document.querySelectorAll(
      '.groupstandings > tbody > tr',
    );

    for (Element row in rows) {
      results.add(TeamTournamentClubResult.fromElement(row));
    }
  } else {
    throw Exception(
      'Der var en fejl ved hentning af data, prøv igen senere eller kontakt udvikler med følgende status kode ${response.statusCode}',
    );
  }

  return results;
}
