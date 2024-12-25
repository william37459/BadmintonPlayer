import 'dart:convert';

import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/dashboard/classes/tournament_result_preview.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/player_profile/functions/get_player_level.dart';
import 'package:app/player_profile/functions/get_player_placement.dart';
import 'package:app/player_profile/functions/get_team_tournament_result.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<PlayerProfile> getPlayerProfile(
  String id,
  String contextKey,
) async {
  http.Response response = await http.post(
    Uri.parse(
      "https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetPlayerProfile",
    ),
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: json.encode({
      "callbackcontextkey": contextKey,
      "getplayerdata": true,
      "playerid": id,
      "seasonid": "2024",
      "showUserProfile": true,
      "showheader": false,
    }),
  );

  if (response.statusCode != 200) {
    return PlayerProfile(
      name: "Denne spiller har ingen tilknyttet profil",
      attachedProfiles: [],
      club: "",
      startLevel: "",
      id: id,
      scoreData: [],
      teamTournaments: [],
      tournaments: [],
      seasons: {},
    );
  }

  final formattedResponse = json.decode(response.body);

  String htmlContent = formattedResponse['d']['Html'];

  Document document = html_parser.parse(htmlContent);

  Element? profiles =
      document.querySelector('.playerprofileuserlist')?.querySelector("tbody");

  List<AttachedProfile> attachedProfiles = [];

  for (Element profile in profiles?.children ?? []) {
    String name = profile.querySelectorAll("td")[0].text.trim();
    String id = profile
            .querySelectorAll("td")[1]
            .querySelector('a')!
            .attributes['href']
            ?.split('=')[1] ??
        "";
    attachedProfiles.add(AttachedProfile(name: name, id: id));
  }
  String points =
      (await getPlayerLevel(id, formattedResponse['d']['playername'].trim()))
          .toString();
  String placement = (await getPlayerPlacement(id)).toString();

  String club = "";

  for (int index = 0;
      index < document.children[0].text.split("\n").length;
      index++) {
    if (document.children[0].text.split("\n")[index] == "Klub") {
      club = document.children[0].text.split("\n")[index + 1];
      break;
    }
  }
  List startLevelList = document
      .querySelectorAll('table')
      .where((element) => element.text.contains("Tilmeldingsniveau"))
      .toList();

  String startLevel = "";

  if (startLevelList.isNotEmpty) {
    startLevel = startLevelList[0].text.split("\n")[2].trim();
  }

  List<Element> gridViews = document.querySelectorAll('.GridView');
  List<ScoreData> scoreData = [];
  List<TeamTournamentResultPreview?> teamTournaments = [];
  List<TournamentResultPreview> tournaments = [];
  Map<String, String> seasons = {};

  List<Element> allSeasons = document.querySelector('select')?.children ?? [];

  for (Element season in allSeasons) {
    seasons[season.text.trim()] = season.attributes['value']!;
  }

  for (Element gridView in gridViews) {
    List<Element> rows = gridView.querySelectorAll('tr');
    if (rows[0].text.contains("Placering")) {
      for (Element row in rows) {
        if (!row.text.contains("Placering")) {
          if (row.text.contains("Tilmeldingsniveau")) {
            scoreData.add(
              ScoreData(
                type: "Samlet",
                rank: row.children[2].text.trim(),
                points: points,
                matches: "",
                placement: placement,
              ),
            );
          } else {
            scoreData.add(
              ScoreData(
                type: row.children[0].text.trim(),
                rank: row.children[2].text.trim(),
                points:
                    row.children.length > 3 ? row.children[3].text.trim() : "",
                matches:
                    row.children.length > 4 ? row.children[4].text.trim() : "",
                placement:
                    row.children.length > 5 ? row.children[5].text.trim() : "",
              ),
            );
          }
        }
      }
    }

    if (rows[0].text.contains("Kampdato")) {
      for (Element row in rows) {
        if (!row.text.contains("Kampdato")) {
          teamTournaments.add(
            await getTeamTournamentResults(
              row.querySelector("a")?.attributes['href']?.split("#")[1] ?? "",
            ),
          );
        }
      }
    }

    teamTournaments.removeWhere((element) => element == null);

    if (rows[0].text.contains("Dato")) {
      for (Element row in rows) {
        if (!row.text.contains("Dato")) {
          tournaments.add(
            TournamentResultPreview.fromElement(
              row,
            ),
          );
        }
      }
    }
  }

  return PlayerProfile(
    name: formattedResponse['d']['playername'].trim(),
    id: id,
    attachedProfiles: attachedProfiles,
    club: club,
    startLevel: startLevel,
    scoreData: scoreData,
    teamTournaments: teamTournaments.cast<TeamTournamentResultPreview>(),
    tournaments: tournaments,
    seasons: seasons,
  );
}
