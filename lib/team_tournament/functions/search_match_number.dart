import 'dart:convert';

import 'package:app/global/constants.dart';
import 'package:app/main.dart';
import 'package:app/team_tournament/index.dart';
import 'package:app/team_tournament_results/match_result/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future searchMatchNumber(
    String matchNumber, WidgetRef ref, BuildContext context) async {
  http.Response response = await http.post(
    Uri.parse(
      "https://www.badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetLeagueStanding",
    ),
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: json.encode({
      "callbackcontextkey": contextKey,
      "subPage": "5",
      "seasonID": "2025",
      "leagueGroupID": "",
      "ageGroupID": "",
      "regionID": "",
      "leagueGroupTeamID": "",
      "leagueMatchID": matchNumber,
      "clubID": "",
      "playerID": ""
    }),
  );

  if (response.statusCode != 200 ||
      response.body.contains("Kampnummer findes ikke")) {
    final scaffoldMessengerState = scaffoldKey.currentState;
    scaffoldMessengerState?.showSnackBar(
      SnackBar(
        elevation: 0,
        content: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              "Kamp ikke fundet",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? searchesJson =
      prefs.getStringList('latestMatchNumberSearches');

  String htmlContent = json.decode(response.body)['d']['html'];

  final document = html_parser.parse(htmlContent);

  List<html.Element> matchElement =
      document.querySelector('.toprow')?.children ?? [];

  String homeTeam =
      matchElement.elementAtOrNull(1)?.text.trim() ?? "Hjemmehold";
  String awayTeam = matchElement.elementAtOrNull(2)?.text.trim() ?? "Udehold";

  await prefs.clear();

  await prefs.setStringList("latestMatchNumberSearches", [
    json.encode({
      "matchnumber": matchNumber,
      "homeTeam": homeTeam,
      "awayTeam": awayTeam,
    }),
    ...searchesJson ?? []
  ]);

  ref.read(leagueMatchIDProvider.notifier).state = matchNumber;

  ref.read(teamTournamentFilterProvider.notifier).state = {
    "region": null,
    "year": null,
    "club": null,
    "matchNumber": null,
    "season": "2023",
  };

  if (!context.mounted) return;
  Navigator.pushNamed(
    context,
    "/TeamTournamentResultPage",
  );
}
