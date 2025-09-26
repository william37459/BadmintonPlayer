import 'dart:convert';

import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/dashboard/classes/tournament_result_preview.dart';
import 'package:app/dashboard/functions/get_team_tournament_results.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/player_profile/functions/get_player_level.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<PlayerProfile?> getPlayerProfilePreview(
  String id,
  String contextKey,
  ref,
) async {
  http.Response response = await http.post(
    Uri.parse(
      "https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetPlayerProfile",
    ),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: json.encode({
      "callbackcontextkey": contextKey,
      "getplayerdata": true,
      "playerid": id,
      "seasonid": null,
      "showUserProfile": true,
      "showheader": false,
    }),
  );

  if (response.statusCode != 200) {
    return null;
  }

  Map formattedResponse = json.decode(response.body);

  String htmlContent = formattedResponse['d']['Html'];

  Document document = html_parser.parse(htmlContent);

  Element? profiles = document
      .querySelector('.playerprofileuserlist')
      ?.querySelector("tbody");

  List<AttachedProfile> attachedProfiles = [];

  for (Element profile in profiles?.children ?? []) {
    String name = profile.querySelectorAll("td")[0].text.trim();
    String id =
        profile
            .querySelectorAll("td")[1]
            .querySelector('a')!
            .attributes['href']
            ?.split('=')[1] ??
        "";
    attachedProfiles.add(AttachedProfile(name: name, id: id));
  }

  String club = "";

  for (
    int index = 0;
    index < document.children[0].text.split("\n").length;
    index++
  ) {
    if (document.children[0].text.split("\n")[index] == "Klub") {
      club = document.children[0].text.split("\n")[index + 1];
      break;
    }
  }

  List<Element> gridViews = document.querySelectorAll('.GridView');
  List<ScoreData> scoreData = [];
  List<TournamentResultPreview> tournaments = [];
  Map<String, String> seasons = {};
  String startLevel = "";

  List<Element> allSeasons = document.querySelector('select')?.children ?? [];

  for (Element season in allSeasons) {
    seasons[season.text.trim()] = season.attributes['value']!;
  }

  for (Element gridView in gridViews) {
    List<Element> rows = gridView.querySelectorAll('tr');

    if (rows[0].text.contains("Placering")) {
      for (Element row in rows) {
        if (!row.text.contains("Placering")) {
          if (row.text.contains("Tilmeldingsniveau") &&
              row.querySelectorAll("a").length < 3) {
            List<int> startValues = (await getPlayerLevel(
              id,
              formattedResponse['d']['playername'].trim(),
            ));

            startLevel = startValues[1] == -1 ? "" : startValues[1].toString();

            scoreData.add(
              ScoreData(
                type: row.children[0].text.trim(),
                rank: row.children[2].text.trim(),
                points: startValues[0] == -1 ? "" : startValues[0].toString(),
                matches: row.children.length > 4
                    ? row.children[4].text.trim()
                    : "",
                placement: startValues[1] == -1
                    ? ""
                    : startValues[1].toString(),
              ),
            );
          } else {
            scoreData.add(
              ScoreData(
                type: row.children[0].text.trim(),
                rank: row.children[2].text.trim(),
                points: row.children.length > 3
                    ? row.children[3].text.trim()
                    : "",
                matches: row.children.length > 4
                    ? row.children[4].text.trim()
                    : "",
                placement: row.children.length > 5
                    ? row.children[5].text.trim()
                    : "",
              ),
            );
          }
        }
      }
    }

    if (rows[0].text.contains("Dato")) {
      for (Element row in rows) {
        if (!row.text.contains("Dato")) {
          tournaments.add(TournamentResultPreview.fromElement(row));
        }
      }
    }
  }

  List<Element> allTeamTournaments =
      document
          .querySelectorAll('.GridView')
          .where((element) => element.text.contains("Kampdato"))
          .firstOrNull
          ?.children
          .firstOrNull
          ?.children ??
      [];
  if (allTeamTournaments.isNotEmpty) allTeamTournaments.removeAt(0);

  List<String> teamTournamentAttributes = [];
  List<String> teamTournamentMatchIds = [];

  for (Element teamTournament in allTeamTournaments) {
    List<String> allAttributes =
        teamTournament
            .querySelectorAll("a")
            .firstOrNull
            ?.attributes['href']
            ?.split(",") ??
        [];
    teamTournamentAttributes.add(allAttributes.join(","));

    allAttributes.removeLast();
    teamTournamentMatchIds.add(allAttributes.last);
  }

  List<TeamTournamentResultPreview> teamTournaments =
      await getTeamTournamentResults(
        teamTournamentAttributes,
        contextKey,
        teamTournamentMatchIds,
      );
  return PlayerProfile(
    name: formattedResponse['d']['playername'].trim(),
    attachedProfiles: [],
    club: club,
    id: id,
    startLevel: startLevel,
    scoreData: scoreData,
    teamTournaments: teamTournaments,
    tournaments: tournaments,
    seasons: seasons,
  );
}
