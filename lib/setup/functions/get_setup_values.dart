import 'dart:convert';
import 'dart:io';

import 'package:app/global/classes/club.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/settings.dart';
import 'package:app/global/classes/user.dart';
import 'package:app/global/constants.dart';
import 'package:app/profile/functions/get_user_info.dart';
import 'package:app/profile/functions/login.dart';
import 'package:app/profile/index.dart';
import 'package:app/settings/index.dart';
import 'package:app/setup/functions/get_profile_search_filters.dart';
import 'package:app/setup/functions/get_ranking_search_filters.dart';
import 'package:app/setup/functions/get_tournament_search_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> getSetupValues(WidgetRef ref) async {
  NavigatorState? navigatorState = navKey.currentState;

  SharedPreferencesAsync prefs = SharedPreferencesAsync();
  String? email = await prefs.getString('email');
  String? password = await prefs.getString('password');
  if (email != null && password != null) {
    await login(email, password, true).then((value) {
      ref.read(isLoggedInProvider.notifier).state = LoginState.isLoggedIn;
      if (value) {
        getUserInfo().then(
          (User user) => ref.read(userProvider.notifier).state = user,
        );
      }
    });
  }

  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  List<String> settingsStringList =
      await asyncPrefs.getStringList('settings') ?? [];
  Settings settings = Settings.fromStringList(settingsStringList);
  ref.read(settingsProvider.notifier).state = settings;

  if (settings.darkMode) {
    ref.read(colorThemeProvider.notifier).state = CustomColorTheme.dark();
  } else {
    ref.read(colorThemeProvider.notifier).state = CustomColorTheme.light();
  }

  await Future.wait([
    getTournamentSearchFilters(),
    getRankSearchFilters(),
    getProfileSearchFilters(),
  ]);

  http.Response response = await http.get(
    Uri.parse('https://badmintonplayer.dk/'),
    headers: {"Content-Type": "application/json; charset=utf-8"},
  );

  List<dynamic> splittedValues = response.body.split("'");

  for (int i = 1; i < splittedValues.length; i++) {
    if (splittedValues[i].toString().contains("CallbackContext")) {
      contextKey = splittedValues[i + 1];
    }
  }

  response = await http.get(
    Uri.parse("https://badmintonplayer.dk/api/Club/all/sportresults"),
  );

  List allClubs = json.decode(response.body);

  if (clubs.isEmpty) {
    for (Map<String, dynamic> club in allClubs) {
      clubs.add(Club.fromJson(club));
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('app_icon');

  // const DarwinInitializationSettings initializationSettingsDarwin =
  //     DarwinInitializationSettings();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true) ??
      false;

  navigatorState?.pushNamedAndRemoveUntil("/MainBuilder", (route) => false);
}
