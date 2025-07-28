import 'dart:convert';

import 'package:app/dashboard/classes/tournament_result_preview.dart';
import 'package:app/global/constants.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<List<TournamentResultPreview>> getTournamentResultsPreview(
  List<String> ids,
  String contextKey,
) async {
  List<TournamentResultPreview> results = [];

  for (String id in ids) {
    http.Response response = await http.post(
      Uri.parse(
        "https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetPlayerProfile",
      ),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: json.encode({
        "callbackcontextkey": contextKey,
        "getplayerdata": true,
        "playerid": id,
        "seasonid": season,
        "showUserProfile": true,
        "showheader": false,
      }),
    );

    if (response.statusCode != 200) {
      continue;
    }

    Map formattedResponse = json.decode(response.body);

    String htmlContent = formattedResponse['d']['Html'];

    Document document = html_parser.parse(htmlContent);

    if (document
        .querySelectorAll("h2")
        .map((e) => e.text.toLowerCase())
        .toList()
        .contains("turneringer")) {
      List<Element> allRows = document
          .querySelectorAll(".GridView")
          .last
          .children
          .first
          .children
          .sublist(1);

      for (var row in allRows) {
        results.add(TournamentResultPreview.fromElement(row));
      }
    }
  }
  return results.sublist(0, 10 > results.length ? results.length : 10);
}
