import 'dart:convert';

import 'package:app/global/classes/profile.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<List<Profile>> getProfiles(Map<String, dynamic> filter) async {
  http.Response response = await http.post(
    Uri.parse(
      'https://badmintonplayer.dk/SportsResults/Components/WebService1.asmx/SearchPlayer',
    ),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
    body: json.encode(filter),
  );

  String htmlContent = json.decode(response.body)['d']['Html'];

  Document document = html_parser.parse(htmlContent);

  List<Profile> profileList = [];

  List<Element> profiles = document.querySelectorAll('tr');

  for (Element profile in profiles) {
    if (profile.attributes['onclick'] != null) {
      final pattern = RegExp(r"'(.*?)'");

      // Find all matches in the input string
      final matches = pattern.allMatches(profile.attributes['onclick']!);

      // Extract and convert the matched values to a list
      List attributes = matches.map((match) => match.group(1)).toList();
      if (attributes.length == 6) {
        String id = attributes[0].trim();
        String badmintonId = attributes[1].trim();
        String name = attributes[2].trim();
        String clubId = attributes[3].trim();
        String club = attributes[4].trim();
        String gender = attributes[5].trim();

        profileList.add(
          Profile(
            id: id,
            badmintonId: badmintonId,
            name: name,
            club: club,
            clubId: clubId,
            gender: gender,
          ),
        );
      }
    }
  }

  return profileList;
}
