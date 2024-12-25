import 'package:app/calendar/index.dart';
import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/dashboard/classes/tournament_result_preview.dart';
import 'package:app/dashboard/functions/get_player_profile_preview.dart';
import 'package:app/dashboard/widgets/team_tournament_result_preview.dart';
import 'package:app/dashboard/widgets/tournament_result_preview_widget.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/player_profile/widgets/ranks_widget.dart';
import 'package:app/player_profile/widgets/toggle_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FutureProvider<PlayerProfile> playerProfileProvider =
    FutureProvider<PlayerProfile>((ref) async {
  final selectedPlayerId = ref.watch(selectedPlayer);
  final results =
      await getPlayerProfilePreview(selectedPlayerId, contextKey, ref);
  return results!;
});

StateProvider<int?> signUpLevel = StateProvider<int?>((ref) {
  return null;
});

class PlayerProfilePage extends ConsumerWidget {
  const PlayerProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorThemeState = ref.watch(colorThemeProvider);
    int choiceIndexState = ref.watch(choiceIndex);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) =>
          ref.read(signUpLevel.notifier).state = null,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  12,
                  8,
                  16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.chevron_left,
                        color: colorThemeState.fontColor.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      "Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorThemeState.fontColor.withValues(alpha: 0.8),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_left,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    AsyncValue<PlayerProfile> futureAsyncValue =
                        ref.watch(playerProfileProvider);
                    return futureAsyncValue.when(
                      error: (error, stackTrace) => Text(
                        error.toString(),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      data: (data) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.25,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              "https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg",
                                            ),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  data.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colorThemeState.fontColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  data.club,
                                  style: TextStyle(
                                    color: colorThemeState.fontColor
                                        .withValues(alpha: 0.6),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                RanksWidget(scores: data.scoreData),
                                const SizedBox(
                                  height: 32,
                                ),
                                const ToggleSwitchButton(
                                  label1: "Holdkampe",
                                  label2: "Turneringer",
                                  enabled: true,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Stack(
                                  children: [
                                    AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      opacity: choiceIndexState == 0 ? 1 : 0,
                                      child: Column(
                                        children: [
                                          if (choiceIndexState == 0)
                                            for (TeamTournamentResultPreview teamTournament
                                                in data.teamTournaments)
                                              TeamTournamentResultPreviewWidget(
                                                result: teamTournament,
                                                width: null,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      opacity: choiceIndexState == 1 ? 1 : 0,
                                      child: Column(
                                        spacing: 8,
                                        children: [
                                          if (choiceIndexState == 1)
                                            for (TournamentResultPreview tournament
                                                in data.tournaments)
                                              TournamentResultPreviewWidget(
                                                result: tournament,
                                                margin: const EdgeInsets.all(0),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
