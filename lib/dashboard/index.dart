import 'package:app/calendar/index.dart';

import 'package:app/dashboard/functions/get_tournament_results_preview.dart';
import 'package:app/dashboard/widgets/add_info_preview.dart';
import 'package:app/dashboard/widgets/consumer_preview_widget.dart';
import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/dashboard/functions/get_player_profile_preview.dart';
import 'package:app/dashboard/functions/get_team_tournament_results.dart';
import 'package:app/dashboard/widgets/player_preview.dart';
import 'package:app/dashboard/widgets/team_tournament_result_preview.dart';
import 'package:app/dashboard/widgets/tournament_preview.dart';
import 'package:app/dashboard/widgets/tournament_result_preview_widget.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/classes/team_tournament_filter.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

FutureProvider<List<PlayerProfile>> playerProfilePreviewProvider =
    FutureProvider<List<PlayerProfile>>((ref) async {
  List<String>? ids = ref.watch(favouritePlayers);

  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  if (ids == null) {
    ref.read(favouritePlayers.notifier).state =
        await asyncPrefs.getStringList("favouritePlayers") ?? [];
  }

  List<Future<PlayerProfile?>> futures = ids!.map((id) async {
    return await getPlayerProfilePreview(
      id,
      contextKey,
      ref,
    );
  }).toList();

  // Wait for all requests to complete
  List<PlayerProfile?> result = await Future.wait(futures);

  result.removeWhere((element) => element == null);

  await asyncPrefs.setStringList(
    'playerScores',
    result.map((e) => "${e!.id}:${e.startLevel}:${e.name}").toList(),
  );

  return result.cast<PlayerProfile>();
});

FutureProvider<List<dynamic>> tournamentResultPreviewProvider =
    FutureProvider<List<dynamic>>((ref) async {
  List<String>? ids = ref.watch(favouritePlayers);
  if (ids == null) {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    ref.read(favouritePlayers.notifier).state =
        await asyncPrefs.getStringList("favouritePlayers") ?? [];
  }
  final result = await getTournamentResultsPreview(
    ids ?? [],
    contextKey,
  );
  return result;
});

FutureProvider<List<TeamTournamentResultPreview>> teamTournamentResultProvider =
    FutureProvider<List<TeamTournamentResultPreview>>((ref) async {
  List<String>? teamIds = ref.watch(favouriteTeams);
  if (teamIds == null) {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    ref.read(favouriteTeams.notifier).state =
        await asyncPrefs.getStringList("favouriteTeams") ?? [];
  }

  final result = await getTeamTournamentResults(
    teamIds ?? [],
    contextKey,
    null,
  );
  return result;
});

class Dashboard extends ConsumerWidget {
  final ScrollController scrollController = ScrollController();

  Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorThemeState.primaryColor,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.only(
            bottom: 32.0,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Velkommen,",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorThemeState.secondaryFontColor
                          .withValues(alpha: 0.8),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Kommende turneringer',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorThemeState.secondaryFontColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ConsumerPreviewWidget(
                  child: (dynamic result) => TournamentPreviewWidget(
                    tournament: result,
                    width: 200,
                  ),
                  provider: seasonPlanFutureProvider,
                  errorText: 'Ingen kommende turneringer',
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: AddInfoPreview(
                    onTap: () => Navigator.of(context)
                        .pushNamed('/TournamentOverviewPage'),
                    text: 'Se alle turneringer',
                    icon: Icons.info,
                    color: colorThemeState.secondaryFontColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PreviewHeader(
                        colorThemeState: colorThemeState,
                        text: 'Favorit spillere',
                      ),
                      AddInfoPreview(
                        onTap: () => Navigator.of(context).pushNamed(
                          '/PlayerSearchPage',
                          arguments: {
                            'favouriteMode': true,
                          },
                        ),
                        text: "Tilføj spillere",
                        icon: Icons.add,
                      ),
                    ],
                  ),
                ),
                ConsumerPreviewWidget(
                  child: (dynamic result) => PlayerPreviewWidget(
                    profile: result,
                  ),
                  provider: playerProfilePreviewProvider,
                  errorText: 'Ingen favorit spillere',
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PreviewHeader(
                        colorThemeState: colorThemeState,
                        text: 'Holdkampe resultater',
                      ),
                      AddInfoPreview(
                        onTap: () {
                          ref
                              .read(teamTournamentSearchFilterProvider.notifier)
                              .state = TeamTournamentFilter.fromJson({
                            "ageGroupID": "",
                            "callbackcontextkey": contextKey,
                            "clubID": "",
                            "leagueGroupID": "",
                            "leagueGroupTeamID": "",
                            "leagueMatchID": "",
                            "playerID": "",
                            "regionID": "",
                            "seasonID": "2024",
                            "subPage": "6"
                          });
                          Navigator.of(context).pushNamed(
                            '/TeamTournamentSearchPage',
                          );
                        },
                        text: "Tilføj hold",
                        icon: Icons.add,
                      ),
                    ],
                  ),
                ),
                ConsumerPreviewWidget(
                  child: (dynamic result) => TeamTournamentResultPreviewWidget(
                    result: result,
                    margin: const EdgeInsets.all(0),
                  ),
                  provider: teamTournamentResultProvider,
                  errorText: 'Ingen holdkamp resultater',
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: PreviewHeader(
                    colorThemeState: colorThemeState,
                    text: "Seneste resultater",
                  ),
                ),
                ConsumerPreviewWidget(
                  child: (dynamic result) => TournamentResultPreviewWidget(
                    result: result,
                  ),
                  provider: tournamentResultPreviewProvider,
                  errorText:
                      'Der er ingen resultater for turneringer i den her sæson',
                  axis: Axis.vertical,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class PreviewHeader extends StatelessWidget {
  final String text;
  const PreviewHeader({
    super.key,
    required this.colorThemeState,
    required this.text,
  });

  final CustomColorTheme colorThemeState;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: colorThemeState.fontColor.withValues(alpha: 0.6),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
