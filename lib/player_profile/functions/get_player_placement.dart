import 'dart:convert';

import 'package:app/global/constants.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<int> getPlayerPlacement(String id) async {
  late http.Response response;

  response = await http.post(
    Uri.parse(
        "https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/GetRankingListPlayers"),
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: json.encode({
      "callbackcontextkey": contextKey,
      "rankinglistagegroupid": "",
      "rankinglistid": "287",
      "seasonid": "2024",
      "rankinglistversiondate": "",
      "agegroupid": "",
      "classid": "",
      "gender": "",
      "clubid": "",
      "searchall": false,
      "regionid": "",
      "pointsfrom": null,
      "pointsto": null,
      "rankingfrom": "",
      "rankingto": "",
      "birthdatefromstring": "",
      "birthdatetostring": "",
      "agefrom": null,
      "ageto": null,
      "playerid": id,
      "param": "",
      "pageindex": 0,
      "sortfield": 0,
      "getversions": true,
      "getplayer": true
    }),
  );

  if (response.statusCode != 200) {
    return 0;
  }

  final formattedResponse = json.decode(response.body)['d']['Html'];

  Document document = html_parser.parse(formattedResponse);

  return int.tryParse(document.querySelectorAll(".rank")[1].text) ?? 0;
}
