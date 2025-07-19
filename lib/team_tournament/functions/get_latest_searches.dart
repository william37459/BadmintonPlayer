import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LatestSearch {
  final String matchNumber;
  final String homeTeam;
  final String awayTeam;

  LatestSearch({
    required this.matchNumber,
    required this.homeTeam,
    required this.awayTeam,
  });

  factory LatestSearch.fromJson(Map<String, dynamic> json) {
    return LatestSearch(
      matchNumber: json['matchnumber'] ?? '',
      homeTeam: json['homeTeam'] ?? '',
      awayTeam: json['awayTeam'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchnumber': matchNumber,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LatestSearch && other.matchNumber == matchNumber;
  }

  @override
  int get hashCode => matchNumber.hashCode;
}

Future<List<LatestSearch>?> getLatestSearches() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? searchesJson =
        prefs.getStringList('latestMatchNumberSearches');

    final List<LatestSearch> latestSearches = searchesJson
            ?.map((item) {
              LatestSearch test = LatestSearch.fromJson(
                  json.decode(item) as Map<String, dynamic>);
              return test;
            })
            .toSet()
            .toList() ??
        [];

    return latestSearches.isEmpty ? null : latestSearches;
  } catch (e) {
    return null;
  }
}
