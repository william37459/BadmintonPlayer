import 'dart:convert';
import 'package:app/global/classes/search_filters/age_group.dart';
import 'package:app/global/classes/search_filters/class_group.dart';
import 'package:app/global/classes/search_filters/region.dart';
import 'package:app/global/classes/search_filters/seasons.dart';
import 'package:app/global/constants.dart';
import 'package:http/http.dart' as http;

Future<void> getTournamentSearchFilters() async {
  http.Response response = await http.get(
    Uri.parse('https://badmintonplayer.dk/api/Seasons'),
  );

  if (response.statusCode == 200) {
    List allSeasons = [];
    List formattedJson = jsonDecode(response.body);

    for (dynamic element in formattedJson) {
      allSeasons.add(Season.fromJson(element));
    }

    seasonPlanSearchFilters.update(
      "seasons",
      (value) => allSeasons,
      ifAbsent: () => allSeasons,
    );
  } else {
    throw Exception('Failed to load seasons');
  }

  response = await http.get(
    Uri.parse('https://badmintonplayer.dk/api/AgeGroup/Get'),
  );

  if (response.statusCode == 200) {
    List allAgeGroups = [];
    List formattedJson = jsonDecode(response.body);
    for (dynamic element in formattedJson) {
      allAgeGroups.add(AgeGroup.fromJson(element));
    }

    seasonPlanSearchFilters.update(
      "ageGroups",
      (value) => allAgeGroups,
      ifAbsent: () => allAgeGroups,
    );
  } else {
    throw Exception('Failed to load age groups');
  }

  response = await http.get(
    Uri.parse('https://badmintonplayer.dk/api/ClassGroup/Get'),
  );

  if (response.statusCode == 200) {
    List allClassGroup = [];
    List formattedJson = jsonDecode(response.body);
    for (dynamic element in formattedJson) {
      allClassGroup.add(Class.fromJson(element));
    }

    seasonPlanSearchFilters.update(
      "class",
      (value) => allClassGroup,
      ifAbsent: () => allClassGroup,
    );
  } else {
    throw Exception('Failed to load classes');
  }

  response = await http.get(
    Uri.parse('https://badmintonplayer.dk/api/GeoRegion/Get'),
  );

  if (response.statusCode == 200) {
    List allGeoRegion = [];
    List formattedJson = jsonDecode(response.body);
    for (dynamic element in formattedJson) {
      allGeoRegion.add(GeoRegion.fromJson(element));
    }

    seasonPlanSearchFilters.update(
      "geoRegions",
      (value) => allGeoRegion,
      ifAbsent: () => allGeoRegion,
    );
  } else {
    throw Exception('Failed to load geo regions');
  }

  response = await http.get(
    Uri.parse('https://badmintonplayer.dk/api/Region'),
  );

  if (response.statusCode == 200) {
    List allRegions = [];
    List formattedJson = jsonDecode(response.body);

    for (dynamic element in formattedJson) {
      allRegions.add(Region.fromJson(element));
    }

    seasonPlanSearchFilters.update(
      "regions",
      (value) => allRegions,
      ifAbsent: () => allRegions,
    );
  } else {
    throw Exception('Failed to load regions');
  }
  return;
}
