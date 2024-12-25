import 'dart:convert';

import 'package:app/global/constants.dart';
import 'package:http/http.dart' as http;

Future<int> getPlayerLevel(String id, String name) async {
  int maximum = 10000;
  int minimum = 0;

  late http.Response response;
  while (maximum - minimum > 2) {
    int mid = minimum + ((maximum - minimum) ~/ 2);
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
        "pointsfrom": "$mid",
        "pointsto": "$maximum",
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
    String rawHTML = json.decode(response.body)['d']['Html'];
    if (rawHTML.toLowerCase().contains(name.toLowerCase())) {
      minimum = mid;
    } else {
      maximum = mid;
    }
  }

  return maximum;
}
