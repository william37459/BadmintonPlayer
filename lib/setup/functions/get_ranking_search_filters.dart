import 'package:app/global/constants.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<void> getRankSearchFilters() async {
  final response = await http.get(
    Uri.parse('https://badmintonplayer.dk/DBF/Ranglister/'),
  );

  if (response.statusCode == 200) {
    List<Map<String, String>> mapParameters = [
      {
        "id": "DropDownListSearchAgeGroup",
        "key": "ageGroup",
      },
      {
        "id": "DropDownListSearchClass",
        "key": "class",
      },
    ];

    String htmlContent = response.body;

    final document = html_parser.parse(htmlContent);

    //Sæson
    for (Map<String, String> parameter in mapParameters) {
      List rows = document.querySelector('#${parameter['id']}')?.children ?? [];
      Map<String, String> data = {};

      for (var row in rows) {
        data.putIfAbsent(
          row.attributes['value'] ?? row.text,
          () => row.text.isEmpty ? "Alle" : row.text,
        );
      }

      rankSearchFilters.putIfAbsent(
        parameter['key'] ?? "",
        () => data,
      );
    }
  } else {
    throw Exception('Failed to load search filters');
  }
  return;
}
