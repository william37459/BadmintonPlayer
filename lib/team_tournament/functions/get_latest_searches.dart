import 'dart:convert';

import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<TeamTournamentResultPreview>?> getLatestSearches() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? searchesJson =
        prefs.getStringList('latestMatchNumberSearches');

    final List<TeamTournamentResultPreview> latestSearches = searchesJson
            ?.map((item) {
              TeamTournamentResultPreview test =
                  TeamTournamentResultPreview.fromJson(
                      json.decode(item) as Map<String, dynamic>);
              return test;
            })
            .toSet()
            .toList() ??
        [];

    return latestSearches.isEmpty ? null : latestSearches;
  } catch (e) {
    return null;
  }
}
