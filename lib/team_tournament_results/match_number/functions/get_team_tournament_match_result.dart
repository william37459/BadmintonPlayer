import 'dart:convert';
import 'package:app/global/classes/team_tournament_result.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<TeamTournamentResult> getTeamTournamentMatchResult(
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

  Map<String, List<String>> allInfo = {};

  String points = "";
  String result = "";
  String homeTeam = "";
  String awayTeam = "";
  List<TeamTournamentMatch> matches = [];

  if (response.statusCode == 200) {
    final document = html_parser.parse(json.decode(response.body)['d']['html']);

    List<Element> rows =
        document.querySelector('.matchinfo')?.querySelectorAll('tr') ?? [];
    points = rows.last.children[1].text;
    rows.removeLast();
    result = rows.last.children[1].text;
    rows.removeLast();

    for (Element row in rows) {
      if (row.children[1].innerHtml.contains("<a>")) {
      } else if (row.children[1].innerHtml.contains("<br>")) {
        allInfo.putIfAbsent(
          row.children[0].text,
          () => row.children[1].innerHtml
              .split("<br>")
              .map((e) => e.contains("<a")
                  ? html_parser.parse(e).querySelector('a')?.text ?? ""
                  : e)
              .toList(),
        );
      } else {
        allInfo.putIfAbsent(
          row.children[0].text,
          () => [row.children[1].text],
        );
      }
    }

    Element? matchResults =
        document.querySelector('.matchresultschema.showmatch');

    for (Element matchResult in matchResults?.children[0].children ?? []) {
      if (matchResult.className == "toprow") {
        awayTeam = matchResult.children[1].text;
        homeTeam = matchResult.children[2].text;
      } else {
        String type = matchResult.children[0].text;
        List<TeamTournamentTeam> teams = [];
        List<TeamTournamentPlayer> players = [];
        List<String> matchPoints = [];
        for (Element player
            in matchResult.querySelector('.player')?.children ?? []) {
          if (player.className != "teamhdr") {
            players.add(
              TeamTournamentPlayer(
                name: player.text,
                id: player
                        .querySelector('a')
                        ?.attributes['href']!
                        .split("#")[1] ??
                    "",
              ),
            );
          }
        }
        for (Element matchPoint in matchResult.querySelectorAll('.result')) {
          matchPoints.add(
            matchPoint.text
                .replaceAll(RegExp(r"\s"), "")
                .replaceAll("-", "")
                .replaceAll(matchPoint.querySelector('b')?.text ?? "", ""),
          );
        }
        teams.add(
          TeamTournamentTeam(
            winner: false,
            players: players,
            points: matchPoints,
          ),
        );
        matchPoints = [];
        players = [];
        for (Element player
            in matchResult.querySelector('.playerwinner')?.children ?? []) {
          if (player.className != "teamhdr") {
            players.add(
              TeamTournamentPlayer(
                name: player.text,
                id: player
                        .querySelector('a')
                        ?.attributes['href']!
                        .split("#")[1] ??
                    "",
              ),
            );
          }
        }
        for (Element matchPoint in matchResult.querySelectorAll('.result')) {
          matchPoints.add(matchPoint.querySelector('b')?.text ?? "");
        }
        teams.add(
          TeamTournamentTeam(
            winner: true,
            players: players,
            points: matchPoints,
          ),
        );
        matches.add(
          TeamTournamentMatch(
            type: type,
            teams: teams,
          ),
        );
      }
    }
  }

  return TeamTournamentResult(
    info: allInfo,
    result: result,
    points: points,
    homeTeam: homeTeam,
    awayTeam: awayTeam,
    matches: matches,
  );
}
