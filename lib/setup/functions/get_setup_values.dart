import 'dart:convert';

import 'package:app/global/classes/club.dart';
import 'package:app/global/constants.dart';
import 'package:app/setup/functions/get_profile_search_filters.dart';
import 'package:app/setup/functions/get_ranking_search_filters.dart';
import 'package:app/setup/functions/get_tournament_search_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

Future<void> getSetupValues() async {
  NavigatorState? navigatorState = navKey.currentState;

  await Future.wait(
    [
      getTournamentSearchFilters(),
      getRankSearchFilters(),
      getProfileSearchFilters(),
    ],
  );

  http.Response response = await http.get(
    Uri.parse(
      'https://badmintonplayer.dk/',
    ),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  List<dynamic> splittedValues = response.body.split("'");

  for (int i = 1; i < splittedValues.length; i++) {
    if (splittedValues[i].toString().contains("CallbackContext")) {
      contextKey = splittedValues[i + 1];
    }
  }

  response = await http.get(
    Uri.parse(
      "https://badmintonplayer.dk/api/Club/all/sportresults",
    ),
  );

  List allClubs = json.decode(response.body);

  for (Map<String, dynamic> club in allClubs) {
    clubs.add(Club.fromJson(club));
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  navigatorState?.pushNamedAndRemoveUntil("/MainBuilder", (route) => false);
}
