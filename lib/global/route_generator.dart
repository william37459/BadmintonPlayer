import 'package:app/calendar/index.dart';
import 'package:app/main_builder/index.dart';
import 'package:app/player_profile/index.dart';
import 'package:app/player_profile_search/index.dart';
import 'package:app/setup/index.dart';
import 'package:app/team_tournament/index.dart';
import 'package:app/team_tournament_results/match_result/index.dart';
import 'package:app/team_tournament_search/index.dart';
import 'package:app/tournament_participant_list/index.dart';
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
      case '/TeamTournamentSearchPage':
        return CupertinoPageRoute(builder: (_) => TeamTournamentSearch());
      case '/PlayerSearchPage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => PlayerSearch(
              favouriteMode: args['favouriteMode'] ?? false,
              shouldReturnPlayer: args['shouldReturnPlayer'] ?? false,
            ),
          );
        }
        return CupertinoPageRoute(builder: (_) => const PlayerSearch());
      case '/PlayerProfilePage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => PlayerProfilePage(player: args['player']),
          );
        }
        return _errorRoute();
      case '/TournamentResultPage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) =>
                TournamentResultPage(tournamentTitle: args['tournament']),
          );
        }
        return _errorRoute();
      case '/TournamentParticipationPage':
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) =>
                TournamentParticipationList(tournament: args['tournament']),
          );
        }
        return _errorRoute();
      case '/TournamentOverviewPage':
        return CupertinoPageRoute(builder: (_) => TournamentPlan());
      case '/TeamTournamentResultPage':
        return CupertinoPageRoute(
          builder: (_) => const TeamTournamentMatchResultWidget(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("Fejl!")),
          body: const Center(child: Text("FEJL")),
        );
      },
    );
  }
}
