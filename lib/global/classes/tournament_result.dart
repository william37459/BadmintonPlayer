import 'package:app/global/classes/profile.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

class TournamentResult {
  final String resultName;
  final List<MatchResult> matches;

  TournamentResult({
    required this.resultName,
    required this.matches,
  });

  factory TournamentResult.fromJson(Map<String, dynamic> json) {
    return TournamentResult(
      resultName: json['resultName'],
      matches: json['matches'],
    );
  }
}

class MatchResult {
  List<Profile> winner;
  List<Profile> loser;
  List<String> result;

  MatchResult({
    required this.winner,
    required this.loser,
    required this.result,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      winner: json['winner'],
      loser: json['loser'],
      result: json['result'],
    );
  }
}

class TournamentInfo {
  String tournamentNumber;
  DateTimeRange date;
  DateTime rsvp;
  List<String> playDates;
  String contactInfo;
  DateTime lastUpdated;

  TournamentInfo({
    required this.tournamentNumber,
    required this.date,
    required this.rsvp,
    required this.playDates,
    required this.contactInfo,
    required this.lastUpdated,
  });

  factory TournamentInfo.fromElements(List<dom.Element> elements) {
    List<String> playDates = [];
    DateTime startDate = DateTime.parse(
      elements[1].children[1].text.split(" ")[1].split("-").reversed.join("-"),
    );
    DateTime endDate = DateTime.parse(
      elements[1].children[1].text.split(" ")[4].split("-").reversed.join("-"),
    );

    DateTime lastUpdated = DateTime.parse(
      "${elements[5].children[1].text.split(" ")[0].split("-").reversed.join("-")} ${elements[5].children[1].text.split(" ")[1]}",
    );

    return TournamentInfo(
      tournamentNumber: elements[0].children[1].text,
      date: DateTimeRange(
        start: startDate,
        end: endDate,
      ),
      rsvp: DateTime.parse(elements[2]
          .children[1]
          .text
          .split(" ")[1]
          .split("-")
          .reversed
          .join("-")),
      playDates: playDates,
      contactInfo: elements[4].children[1].text,
      lastUpdated: lastUpdated,
    );
  }
}
