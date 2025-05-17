import 'dart:convert';

import 'package:app/global/classes/profile.dart';
import 'package:app/global/classes/tournament_result.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<List<TournamentResult>> getTeamTournamentMatchResult(
    String contextKey, String leagueMatchID) async {
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
        "subPage": "5",
        "seasonID": "",
        "leagueGroupID": "",
        "ageGroupID": "",
        "regionID": "",
        "leagueGroupTeamID": "",
        "leagueMatchID": leagueMatchID,
        "clubID": "",
        "playerID": ""
      },
    ),
  );

  List<TournamentResult> results = [];

  if (response.statusCode == 200) {
    final document = html_parser.parse(json.decode(response.body)['d']['html']);

    List<Element> rows = document.querySelector('body')?.children ?? [];

    rows = document
            .querySelector('.matchresultschema.showmatch')
            ?.children
            .first
            .children ??
        [];

    for (Element row in rows) {
      if (!row.classes.contains("toprow")) {
        String type = row.children[0].text.trim();

        List<Profile> winners = [];
        List<Profile> losers = [];

        for (int index = 1; index < 3; index++) {
          Element? playerElement = row.children[index];
          List<Profile> players = [];
          String club = playerElement.children[0].text.trim();
          players.add(
            Profile(
              name: playerElement.children[1].text.trim(),
              club: club,
              id: "",
              badmintonId: "",
              gender: "",
              clubId: "",
            ),
          );
          if (playerElement.children.length > 2) {
            players.add(
              Profile(
                name: playerElement.children[2].text.trim(),
                club: club,
                id: "",
                badmintonId: "",
                gender: "",
                clubId: "",
              ),
            );
          }
          if (playerElement.classes.contains("playerwinner")) {
            winners = players;
          } else {
            losers = players;
          }
        }
        List<String> result = [];

        for (int index = 3; index < 6; index++) {
          Element? resultElement = row.children[index];
          if (resultElement.text.trim().isNotEmpty) {
            List<int> correctedResult = resultElement.text
                .trim()
                .split("-")
                .map((e) => int.tryParse(e.trim()) ?? 0)
                .toList();
            correctedResult.sort();
            correctedResult = correctedResult.reversed.toList();

            result.add(correctedResult.join("/"));
          }
        }

        results.add(
          TournamentResult(
            resultName: type,
            matches: [
              MatchResult(
                winner: winners,
                loser: losers,
                result: result,
              ),
            ],
          ),
        );
      }
    }
  }
  return results;
}
