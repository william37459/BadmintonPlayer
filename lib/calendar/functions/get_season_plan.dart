import 'dart:convert';
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
    Map filterValues, String contextKey) async {
  Map localFilterValues = {
    ...filterValues,
  };

  localFilterValues["ageGroupList"] = filterValues["ageGroupList"].isEmpty
      ? []
      : [filterValues["ageGroupList"]];

  localFilterValues["classIdList"] =
      filterValues["classIdList"].isEmpty ? [] : [filterValues["classIdList"]];

  if (filterValues.containsKey("clubIds")) {
    if (filterValues["clubIds"] is List) {
    } else if (int.tryParse(filterValues["clubIds"].toString()) == null) {
      filterValues.remove("clubIds");
    } else {
      localFilterValues["clubIds"] = [filterValues["clubIds"]];
    }
  }

  if (filterValues.containsKey("dateFrom") &&
      (filterValues["dateFrom"] == null || filterValues["dateFrom"].isEmpty)) {
    filterValues.remove("dateFrom");
  }

  if (filterValues.containsKey("dateTo") &&
      (filterValues["dateTo"] == null || filterValues["dateTo"].isEmpty)) {
    filterValues.remove("dateTo");
  }

  if (filterValues.containsKey("dateFrom")) {
    List<String> dateValues = filterValues['dateFrom'].split("-");
    dateValues[0] = dateValues[0].padLeft(2, "0");
    dateValues[1] = dateValues[1].padLeft(2, "0");

    localFilterValues["dateFrom"] =
        "${dateValues.reversed.join("-")}T00:00:00.000Z";
  }

  if (filterValues.containsKey("dateTo")) {
    List<String> dateValues = filterValues['dateTo'].split("-");
    dateValues[0] = dateValues[0].padLeft(2, "0");
    dateValues[1] = dateValues[1].padLeft(2, "0");

    localFilterValues["dateTo"] =
        "${dateValues.reversed.join("-")}T00:00:00.000Z";
  }

  //TODO Vis Madsen dato filter ikke virker haha

  http.Response response = await http.patch(
    Uri.parse(
      "https://badmintonplayer.dk/api/Tournament",
    ),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
    body: json.encode({
      ...localFilterValues,
    }),
  );

  print(filterValues);

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
