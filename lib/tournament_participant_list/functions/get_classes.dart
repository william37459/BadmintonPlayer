import 'dart:convert';

import 'package:app/tournament_participant_list/classes/tournament_class.dart';
import 'package:http/http.dart' as http;

Future<List<TournamentClass>> getClasses(int tournamentId) async {
  http.Response response = await http.get(
    Uri.parse(
      "https://www.badmintonplayer.dk/api/TournamentClass?tournamentClassId=$tournamentId",
    ),
  );

  List<TournamentClass> classes = [];
  if (response.statusCode != 200) {
    return [];
  } else {
    final Map jsonData = json.decode(response.body) as Map;

    for (var item
        in jsonData.containsKey("tournamentClasses")
            ? jsonData["tournamentClasses"]
            : jsonData["tournamentClasses"] as List) {
      classes.add(TournamentClass.fromJson(item as Map<String, dynamic>));
    }

    classes.sort((a, b) => a.ageGroupName.compareTo(b.ageGroupName));

    return classes;
  }
}
