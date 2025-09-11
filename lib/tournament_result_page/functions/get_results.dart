import 'dart:convert';

import 'package:app/global/classes/profile.dart';
import 'package:app/global/classes/tournament_result.dart';
import 'package:app/tournament_result_page/functions/get_info.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<Map<String, dynamic>> getResults(
  Map filterValues,
  String contextKey,
  int selectedTournament,
) async {
  final response = await http.post(
    Uri.parse(
      'https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/SearchTournamentMatches',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode({
      ...filterValues,
      "callbackcontextkey": contextKey,
      "tournamentclassid": selectedTournament,
    }),
  );

  List<TournamentResult> result = [];

  if (response.statusCode == 200) {
    TournamentInfo info = await getInfo(response);
    String htmlContent = json.decode(response.body)['d']['Html'];

    Document document = html_parser.parse(htmlContent);

    List<MatchResult> matches = [];
    Map<String, Map<String, dynamic>> filters = {
      "matchType": {},
      "class": {},
      "club": {},
      "player": {},
    };
    String resultName = "";

    var rows = document.querySelectorAll('.smallTab, .smallTabSelected');

    for (final row in rows) {
      String input = row.querySelector("a")?.attributes["onclick"] ?? "";

      // Split the string by single quotes and commas
      List<String> attributes = input.split(RegExp("[',]"));

      // Remove empty attributes
      attributes = attributes
          .where((attribute) => attribute.isNotEmpty)
          .toList();

      String label = row.text;
      int id = int.parse(attributes[2]);

      filters['matchType']?.putIfAbsent(label, () => id);
    }

    List<String> possibleMatchSetups = [
      "mixdouble",
      "herredouble",
      "damedouble",
      "herresingle",
      "damesingle",
      "single (m/k)",
      "double (m/k)",
    ];

    filters['matchType']?.removeWhere(
      (key, value) => !possibleMatchSetups.contains(key.toLowerCase()),
    );

    Document classFilters = html_parser.parse(
      json.decode(response.body)['d']['ClassInfo'],
    );

    rows = classFilters.querySelector('.selectbox')?.children ?? [];

    for (Element row in rows) {
      String label = row.text;
      String id = row.attributes['value'] ?? "";

      filters['class']?.putIfAbsent(id, () => label);
    }

    rows = document.querySelectorAll('select');

    for (int index = 0; index < 2; index++) {
      for (Element row in rows[index].children) {
        String label = row.text;
        String id = row.attributes['value'] ?? "";

        filters[index == 0 ? 'club' : 'player']?.putIfAbsent(id, () => label);
      }
    }

    rows = document.querySelectorAll('tr');

    for (final row in rows) {
      if (row.classes.contains("headrow")) {
        if (matches.isNotEmpty) {
          result.add(
            TournamentResult(resultName: resultName, matches: matches),
          );
        }
        resultName = row.text.trim().split(" - ")[0];
        matches = [];
      } else if (row.querySelectorAll('.player').isNotEmpty) {
        List<Profile> winners = [];
        List<Profile> losers = [];

        row
            .querySelectorAll('.player')[0]
            .innerHtml
            .split("<br>")
            .map((e) => html_parser.parse(e));

        row.querySelectorAll('.player')[0].innerHtml.split("<br>").forEach((
          element,
        ) {
          Document player = html_parser.parse(element);
          if (element.isNotEmpty) {
            winners.add(
              Profile(
                name: player.querySelector('a')?.text ?? "",
                club: player.body?.text.split(", ")[1].trim() ?? "",
                id: "",
                badmintonId: "",
                gender: "",
                clubId: "",
              ),
            );
          }
        });

        row.querySelectorAll('.player')[1].innerHtml.split("<br>").forEach((
          element,
        ) {
          Document player = html_parser.parse(element);
          if (element.isNotEmpty) {
            losers.add(
              Profile(
                name: player.querySelector('a')?.text ?? "",
                club: player.body?.text.split(", ")[1].trim() ?? "",
                id: "",
                badmintonId: "",
                gender: "",
                clubId: "",
              ),
            );
          }
        });

        List<String> result =
            row.querySelector('.result')?.text.trim().split(",") ?? [];

        result = result
            .map(
              (e) => e
                  .split("/")
                  .map((e) => e.replaceAll(RegExp(r'[^0-9]'), ''))
                  .join("/"),
            )
            .toList();

        matches.add(
          MatchResult(winner: winners, loser: losers, result: result),
        );
      }
    }
    if (matches.isNotEmpty) {
      result.add(TournamentResult(resultName: resultName, matches: matches));
    }

    return {"results": result, "filters": filters, "info": info};
  }
  return {};
}
