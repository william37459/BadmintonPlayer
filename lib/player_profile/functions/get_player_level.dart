import 'dart:convert';

import 'package:app/global/constants.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<List<int>> getPlayerLevel(String id, String name) async {
  int minimum = 0;
  int maximum = 5000;
  int steps = 5;

  int stepLength = ((maximum - minimum) ~/ steps);

  late List<Result> results;
  late int resultIndex;

  while (stepLength > 1) {
    List<int> intervals = [
      for (int i = minimum; i <= maximum; i += stepLength) i
    ];

    List<Future<Result>> futures = intervals.map((start) async {
      return await containsName(id, name, start, start + stepLength);
    }).toList();

    results = await Future.wait(futures);

    resultIndex = results.lastIndexWhere((result) => result.hasName);

    if (resultIndex == -1) {
      return [-1, -1];
    }

    minimum += resultIndex * stepLength;
    maximum = minimum + stepLength;
    stepLength = ((maximum - minimum) ~/ steps);
  }

  // late Result containsPlayer;
  // while (maximum - minimum > 2) {
  //   int mid = minimum + ((maximum - minimum) ~/ 2);
  //   containsPlayer = await containsName(id, name, mid, maximum);

  //   if (containsPlayer.hasName) {
  //     minimum = mid;
  //   } else {
  //     maximum = mid;
  //   }
  // }

  return [maximum - 1, results[resultIndex].rank];
}

Future<Result> containsName(String id, String name, int start, int end) async {
  http.Response response = await http.post(
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
      "pointsfrom": "$start",
      "pointsto": "$end",
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
    if (end - start < 100 && end - start > 10) {
      Document row = html_parser.parse(rawHTML);
      for (Element element in row.querySelectorAll('tr')) {
        if (element.text.toLowerCase().contains(name.toLowerCase())) {
          return Result(
            true,
            int.parse(element.querySelector('.rank')!.text),
          );
        }
      }
    }
    return Result(true, -1);
  } else {
    return Result(false, -1);
  }
}

class Result {
  final bool hasName;
  final int rank;

  Result(this.hasName, this.rank);
}
