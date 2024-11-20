import 'package:app/main_builder/index.dart';
import 'package:app/player_profile/index.dart';
import 'package:app/setup/index.dart';
import 'package:app/team_tournament/index.dart';
import 'package:app/team_tournament_results/all_matches/index.dart';
import 'package:app/team_tournament_results/club/index.dart';
import 'package:app/team_tournament_results/match_number/index.dart';
import 'package:app/team_tournament_results/position/index.dart';
import 'package:app/team_tournament_results/region/index.dart';
import 'package:app/team_tournament_results/results/index.dart';
import 'package:app/tournament_participation_list/index.dart';
import 'package:app/tournament_result_page/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => const SetupWidget());
      case '/MainBuilder':
        return CupertinoPageRoute(builder: (_) => const MainBuilder());
      case '/TeamTournamentPage':
        return CupertinoPageRoute(builder: (_) => const TeamTournamentPage());
      case '/TeamTournamentRegionPage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => TeamTournamentRegionPage(
              region: args['region'],
              rank: args['rank'],
            ),
          );
        }
        return _errorRoute();

      case '/PlayerProfilePage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => PlayerProfilePage(
              name: args['name'],
              id: args['id'],
            ),
          );
        }
        return _errorRoute();
      case '/TournamentResultPage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => TournamentResultPage(
              tournamentTitle: args['tournament'],
            ),
          );
        }
        return _errorRoute();
      case '/TournamentParticipationPage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => TournamentParticipationList(
              tournament: args['tournament'],
            ),
          );
        }
        return _errorRoute();
      case '/TeamTournamentClubPage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => TeamTournamentClubPage(
              club: args['club'],
            ),
          );
        }
        return _errorRoute();
      case '/TeamTournamentMatchResultPage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => TeamTournamentResultWidget(
              matchNumber: args['matchNumber'],
            ),
          );
        }
        return _errorRoute();
      case '/TeamTournamentPositionPage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => TeamTournamentPositionWidget(
              title: args['title'],
            ),
          );
        }
        return _errorRoute();
      case '/TeamTournamentResultPage':
        return CupertinoPageRoute(
          builder: (_) => const TeamTournamentClubResultsWidget(),
        );
      case '/AllTeamTournamentMatchesPage':
        return CupertinoPageRoute(
          builder: (_) => const AllTeamTournamentMatchesWidget(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Fejl!"),
        ),
        body: const Center(
          child: Text("FEJL"),
        ),
      );
    });
  }
}
