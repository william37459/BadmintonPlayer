import 'dart:convert';

import 'package:app/global/classes/tournament_result.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<TournamentInfo> getInfo(http.Response response) async {
  String htmlContent = json.decode(response.body)['d']['ClassInfo'];

  Document document = html_parser.parse(htmlContent);

  TournamentInfo info = TournamentInfo.fromElements(
    document.querySelector("table > tbody")?.children ?? [],
  );
  return info;
}
