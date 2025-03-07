import 'dart:async';

import 'package:app/player_profile/functions/get_player_level.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> newPlayerResults() async {
  SharedPreferencesAsync prefs = SharedPreferencesAsync();
  await prefs.remove('playerScores');
  List<Map<String, dynamic>> lastPlayerCount =
      (await prefs.getStringList('playerScores'))
              ?.map(
                (e) => {
                  "player": int.tryParse(e.split(":")[0]) ?? 0,
                  "points": int.tryParse(e.split(":")[1]) ?? 0,
                  "name": e.split(":")[2],
                },
              )
              .toList() ??
          [];

  for (Map<String, dynamic> player in lastPlayerCount) {
    int newPoints = (await getPlayerLevel(
      player['player'].toString(),
      player['name'],
    ))[0];
    if (newPoints != player['points']) {
      return true;
    }
  }

  return true;
}
