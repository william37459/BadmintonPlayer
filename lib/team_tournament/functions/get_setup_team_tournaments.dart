import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<List<Map<String, String>>> getSetupTeamTournaments() async {
  http.Response response = await http.get(
    Uri.parse('https://badmintonplayer.dk/DBF/HoldTurnering/Stilling/'),
  );

  List<Map<String, String>> result = [];

  if (response.statusCode == 200) {
    String htmlContent = response.body;

    final document = html_parser.parse(htmlContent);

    Element? allOptions = document.querySelector(
      '#ctl00_ContentPlaceHolder1_ShowStandings1_DropDownListRegion',
    );

    Map<String, String> region = {};

    for (Element option in allOptions?.children ?? []) {
      region[option.attributes['value'] ?? ""] = option.text;
    }

    result.add(region);

    allOptions = document.querySelector(
        '#ctl00_ContentPlaceHolder1_ShowStandings1_DropDownListAgeGroup');
    Map<String, String> year = {};

    for (Element option in allOptions?.children ?? []) {
      year[option.attributes['value'] ?? ""] = option.text;
    }
    result.add(year);

    allOptions = document.querySelector(
        '#ctl00_ContentPlaceHolder1_ShowStandings1_DropDownListSeason');
    Map<String, String> seasons = {};

    for (Element option in allOptions?.children ?? []) {
      seasons[option.attributes['value'] ?? ""] = option.text;
    }

    result.add(seasons);
  }

  return result;
}
