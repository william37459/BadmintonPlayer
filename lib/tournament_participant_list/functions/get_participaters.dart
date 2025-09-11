import 'dart:convert';

import 'package:app/global/constants.dart';
import 'package:app/tournament_participant_list/classes/participant.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

Future<List<Participant>> getParticipaters(int selectedTournament) async {
  http.Response response = await http.post(
    Uri.parse(
      "https://www.badmintonplayer.dk/SportsResults/Components/WebService1.asmx/SearchRegistrationsByClass",
    ),
    headers: {"Content-Type": "application/json; charset=UTF-8"},
    body: json.encode({
      "callbackcontextkey": contextKey,
      "tournamentclassid": selectedTournament,
      "clientselectfunction": "SelectTournamentClass1",
    }),
  );
  List<Participant> participants = [];
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData =
        json.decode(response.body) as Map<String, dynamic>;

    Document participantList = html_parser.parse(jsonData['d']['Html']);
    String type = "Ikke oplyst";
    for (Element row
        in participantList.querySelector(".orderconfirmation")?.children ??
            []) {
      if (row.localName == "h3") {
        type = row.text.trim();
      } else if (row.localName == "table") {
        for (Element participant in row.querySelectorAll("tbody > tr")) {
          if (participant.querySelectorAll("th").isNotEmpty) {
            continue;
          }
          participants.add(Participant.fromHtml(participant, type));
        }
      }
    }
    participants.sort((a, b) {
      return a.type.compareTo(b.type);
    });
    return participants;
  }
  return [];
}
