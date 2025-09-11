import 'dart:convert';

import 'package:app/global/classes/player_score.dart';
import 'package:app/global/constants.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<Map<String, List<PlayerScore>>> getAllScoreLists(Map body) async {
  List allScoreList = await Future.wait([
    getScoreList("", 287, body),
    getScoreList("M", 288, body),
    getScoreList("K", 288, body),
    getScoreList("M", 289, body),
    getScoreList("K", 289, body),
    getScoreList("M", 292, body),
    getScoreList("K", 292, body),
  ]);
  return {
    "287": allScoreList[0],
    "288M": allScoreList[1],
    "288K": allScoreList[2],
    "289M": allScoreList[3],
    "289K": allScoreList[4],
    "292M": allScoreList[5],
    "292K": allScoreList[6],
  };
}

Future<List<PlayerScore>> getScoreList(
  String param,
  int rankinglistid,
  Map body,
) async {
  http.Response response = await http.post(
    Uri.parse(
      'https://www.badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetRankingListPlayers',
    ),
    headers: {"Content-Type": "application/json; charset=utf-8"},
    body: json.encode({
      ...body,
      "callbackcontextkey": contextKey,
      "rankinglistid": rankinglistid,
      "param": param,
    }),
  );

  String htmlContent = json.decode(response.body)['d']['Html'];

  Document document = html_parser.parse(htmlContent);

  List<PlayerScore> peopleList = [];

  List<Element> people = document.querySelectorAll('tr');
  people.removeLast();
  for (Element person in people) {
    if (person.querySelector(".rank.sort") != null) {
      continue;
    } else {
      String rank = person.querySelector(".rank")!.text.trim();
      String badmintonId = person.querySelector(".playerid")!.text.trim();
      String rankClass = person.querySelector(".clas")!.text.trim();
      String name = person.querySelector(".name")!.text.trim().split(", ")[0];
      String id =
          person
              .querySelector(".name")!
              .querySelector('a')
              ?.attributes['href']
              ?.split("#")[1] ??
          "";
      String? club =
          person.querySelector(".name")!.text.trim().split(", ").length > 1
          ? person.querySelector(".name")!.text.trim().split(", ")[1]
          : null;
      String? points = person.querySelector(".points.points")!.text.trim();

      peopleList.add(
        PlayerScore(
          badmintonId: badmintonId,
          id: id,
          name: name,
          rank: rank,
          rankClass: rankClass,
          club: club,
          points: points.isEmpty ? null : points,
        ),
      );
    }
  }

  peopleList.removeWhere((element) => int.tryParse(element.rank) == null);

  return peopleList;
}
