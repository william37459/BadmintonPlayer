import 'package:app/global/classes/club.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String contextKey = "";
String cookies = "";
GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
List<Club> clubs = [];

Map<String, List<dynamic>> seasonPlanSearchFilters = {};
Map<String, dynamic> rankSearchFilters = {};
Map<String, dynamic> profileSearchFilters = {};

List<TeamTournamentFilter> teamTournamentSearchFilterStack = [];

StateProvider<CustomColorTheme> colorThemeProvider =
    StateProvider<CustomColorTheme>((ref) {
      return CustomColorTheme(
        primaryColor: const Color(0xffDF2026),
        secondaryColor: const Color(0xff960E13),
        fontColor: Colors.black,
        secondaryFontColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.3),
      );
    });

StateProvider<Map<String, bool>> isExpandedProvider =
    StateProvider<Map<String, bool>>((ref) => {});

StateProvider<String> selectedTournament = StateProvider<String>((ref) => "");

StateProvider<String> selectedPlayer = StateProvider<String>((ref) => "");

StateProvider<List<String>?> favouritePlayers = StateProvider<List<String>?>(
  (ref) => null,
);

StateProvider<List<String>?> favouriteTeams = StateProvider<List<String>?>(
  (ref) => null,
);

String? findKeyByValue(String? value, Map<String, dynamic> map) {
  for (var entry in map.entries) {
    if (entry.value == value) {
      return entry.key;
    }
  }
  return ""; // Return null if the value is not found in the map
}

StateProvider<TeamTournamentFilter> teamTournamentSearchFilterProvider =
    StateProvider<TeamTournamentFilter>((ref) {
      return TeamTournamentFilter(
        text: "",
        clubID: "",
        leagueGroupID: "",
        leagueGroupTeamID: "",
        leagueMatchID: "",
        ageGroupID: "",
        playerID: "",
        regionID: "",
        seasonID: "",
        subPage: "",
      );
    });

String season = DateTime.now().month >= 7
    ? "${DateTime.now().year + 1}"
    : "${DateTime.now().year}";
