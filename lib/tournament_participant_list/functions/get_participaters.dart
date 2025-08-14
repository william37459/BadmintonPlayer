import 'dart:convert';
import 'package:app/global/classes/participant.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<Map<String, dynamic>> getParticipaters(
    Map filterValues, String contextKey, String selectedTournament) async {
  final response = await http.post(
    Uri.parse(
      'https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/SearchRegistrationsByClass',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode({
      ...filterValues,
      "callbackcontextkey": contextKey,
      "tournamentclassid": selectedTournament,
    }),
  );

  List<Participant> result = [];
  Map<String, String> allFiltersMap = {};

  if (response.statusCode == 200) {
    String htmlContent = json.decode(response.body)['d']['Html'];

    String allFilters = json.decode(response.body)['d']['ClassInfo'];

    final document = html_parser.parse(htmlContent);

    Element? allFiltersElement =
        html_parser.parse(allFilters).querySelector('.selectbox');

    for (Element option in allFiltersElement?.children ?? []) {
      allFiltersMap[option.attributes['value'] ?? ""] = option.text;
    }

    Element? allGrids = document.querySelector('.orderconfirmation');

    String category = "";
    List<PlayerParticipant> players = [];
    String registrant = "";

    for (Element? grid in allGrids?.children ?? []) {
      if (grid != null) {
        if (grid.localName == "h3") {
          category = grid.text;
        } else if (grid.classes.contains("GridView")) {
          List<Element?> rows = grid.querySelectorAll('tr');
          for (Element? row in rows) {
            if (row?.querySelectorAll('th').isEmpty ?? false) {
              registrant = row?.querySelectorAll('td')[1].text ?? "";
              List<String> allPlayers =
                  row?.querySelectorAll('td')[0].innerHtml.split("<br>") ?? [];
              allPlayers.removeWhere((element) => element == "");
              players = [];
              for (String player in allPlayers) {
                if (player == "X-makker") {
                  players.add(
                    PlayerParticipant(
                      name: "X-makker",
                      club: "",
                      badmintonId: "",
                      id: "",
                    ),
                  );
                } else {
                  Element playerInfo = Element.html("<div>$player</div>");
                  String name = playerInfo.querySelector("a")?.text ?? "";
                  String club = "";
                  if (playerInfo.text.split(", ").length > 1) {
                    club = playerInfo.text.split(", ")[1];
                  }
                  final String badmintonId = playerInfo.text.split(" ")[0];
                  final String id = playerInfo
                          .querySelector("a")
                          ?.attributes["href"]
                          ?.split("#")[1] ??
                      "";
                  players.add(
                    PlayerParticipant(
                      name: name,
                      club: club,
                      badmintonId: badmintonId,
                      id: id,
                    ),
                  );
                }
              }
              result.add(
                Participant(
                  registrator: registrant,
                  category: category,
                  players: players,
                ),
              );
            }
          }
        }
      }
    }
  }

  result.sort((a, b) => a.category.compareTo(b.category));
  return {"filters": allFiltersMap, "data": result};
}
