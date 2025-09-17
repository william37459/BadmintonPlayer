import 'dart:convert';
import 'package:app/calendar/classes/season_plan_search_filter.dart';
import 'package:app/global/classes/tournament.dart';
import 'package:http/http.dart' as http;

Map<String, String> monthToNumber = {
  'januar': '01',
  'februar': '02',
  'marts': '03',
  'april': '04',
  'maj': '05',
  'juni': '06',
  'juli': '07',
  'august': '08',
  'september': '09',
  'oktober': '10',
  'november': '11',
  'december': '12',
};

Future<List<Tournament>> getSeasonPlan(
  SeasonPlanSearchFilter filterValues,
) async {
  http.Response response = await http.patch(
    Uri.parse("https://badmintonplayer.dk/api/Tournament"),
    headers: {"Content-Type": "application/json; charset=utf-8"},
    body: json.encode(filterValues.toJson()),
  );

  List<Tournament> tournamentList = [];
  List<TournamentDetails> tournamentDetailsList = [];

  if (response.statusCode == 200) {
    Map formattedResponse = json.decode(response.body);
    for (Map<String, dynamic> tournamentDetail
        in formattedResponse["tournaments"]) {
      tournamentDetailsList.add(TournamentDetails.fromJson(tournamentDetail));
    }

    for (Map<String, dynamic> tournament
        in formattedResponse["tournamentAdmins"]) {
      tournamentList.add(
        Tournament.fromJson(
          tournament,
          tournamentDetailsList
              .where(
                (element) => element.tournamentID == tournament["tournamentID"],
              )
              .toList(),
        ),
      );
    }
  }
  return tournamentList;

  // print(json.decode(response.body)['d']['html']);
}
