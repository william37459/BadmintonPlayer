import 'dart:convert';

import 'package:app/global/classes/player_profile.dart';
import 'package:app/player_profile/functions/get_player_level.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<PlayerProfile?> getPlayerProfilePreview(
  String id,
  String contextKey,
  FutureProviderRef<List<PlayerProfile>> ref,
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

  String club = "";

  for (int index = 0;
      index < document.children[0].text.split("\n").length;
      index++) {
    if (document.children[0].text.split("\n")[index] == "Klub") {
      club = document.children[0].text.split("\n")[index + 1];
      break;
    }
  }
  Element startLevelElement = document
      .querySelectorAll('.GridView')
      .where(
        (element) => element.text.contains("Tilmeldingsniveau"),
      )
      .toList()
      .first
      .children
      .first
      .children[1];

  String startLevel = "";

  if (startLevelElement.children.length > 3) {
    startLevel = startLevelElement.children[3].text;
  } else {
    startLevel =
        (await getPlayerLevel(id, formattedResponse['d']['playername'].trim()))
            .toString();
  }

  List<Element> gridViews = document.querySelectorAll('.GridView');
  List<ScoreData> scoreData = [];
  List<TeamTournament> teamTournaments = [];
  List<PlayerTournament> tournaments = [];
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

    if (rows[0].text.contains("Kampdato")) {
      for (Element row in rows) {
        if (!row.text.contains("Kampdato")) {
          teamTournaments.add(
            TeamTournament(
              date: DateTime.parse(
                  "${row.children[0].text.split(" ")[0].split("-").reversed.join("-")} ${row.children[0].text.split(" ")[1]}"),
              rank: row.children[1].text.trim(),
              team: row.children[2].text.trim(),
              opponent: row.children[3].text.trim(),
            ),
          );
        }
      }
    }

    if (rows[0].text.contains("Dato")) {
      for (Element row in rows) {
        if (!row.text.contains("Dato")) {
          tournaments.add(
            PlayerTournament(
              date: DateTime.parse(
                  row.children[0].text.trim().split("-").reversed.join("-")),
              club: row.children[1].text.trim(),
              rank: row.children[3].text.trim(),
              id: row.children[3]
                      .querySelector('a')
                      ?.attributes['href']
                      ?.split("#")[1]
                      .replaceAll(RegExp(r'[^0-9]'), "") ??
                  "",
            ),
          );
        }
      }
    }
  }

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
