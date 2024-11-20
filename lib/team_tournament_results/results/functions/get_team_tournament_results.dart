import 'dart:convert';

import 'package:app/global/classes/team_tournament_club_result.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<TeamTournamentResults> getTeamTournamentResults(
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

  List<TeamTournamentResultTeam> teams = [];
  List<TeamTournamentFilter> buttons = [];

  if (response.statusCode == 200) {
    final document = html_parser.parse(json.decode(response.body)['d']['html']);

    List<Element> rows = document.querySelector('body')?.children ?? [];

    for (Element row in rows) {
      if (row.localName == "a" && row.attributes.containsKey("onclick")) {
        buttons.add(
          TeamTournamentFilter.fromString(
            row.attributes['onclick'] ?? "",
            row.text.trim(),
          ),
        );
      }
    }

    rows = document.querySelector('.matchlist')?.children[0].children ?? [];

    for (Element row in rows) {
      if (!row.classes.contains("headerrow")) {
        String time = row.querySelector('.time')?.text.trim() ?? "";
        TeamTournamentFilter matchNumber = TeamTournamentFilter.fromString(
          row
                  .querySelector('.matchno')
                  ?.querySelector('a')
                  ?.attributes['onclick'] ??
              "",
          row.querySelector('.matchno')?.text.trim() ?? "",
        );
        TeamTournamentFilter homeTeam = TeamTournamentFilter.fromString(
          row
                  .querySelectorAll('.team')[0]
                  .querySelector('a')
                  ?.attributes['onclick'] ??
              "",
          row.querySelectorAll('.team')[0].text.trim(),
        );
        TeamTournamentFilter awayTeam = TeamTournamentFilter.fromString(
          row
                  .querySelectorAll('.team')[1]
                  .querySelector('a')
                  ?.attributes['onclick'] ??
              "",
          row.querySelectorAll('.team')[1].text.trim(),
        );
        String arranger = row.querySelectorAll('.team')[2].text.trim();
        String place = row.querySelector('.venue')?.text.trim() ?? "";
        String result = row.querySelector('.score')?.text.trim() ?? "";
        String points = row.querySelector('.points')?.text.trim() ?? "";
        teams.add(
          TeamTournamentResultTeam(
            time: time,
            matchNumber: matchNumber,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            arranger: arranger,
            place: place,
            result: result,
            points: points,
          ),
        );
      }
    }
  }
  return TeamTournamentResults(
    buttons: buttons,
    teams: teams,
  );
}
