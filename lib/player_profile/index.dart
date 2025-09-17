import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/dashboard/classes/tournament_result_preview.dart';
import 'package:app/dashboard/widgets/team_tournament_result_preview.dart';
import 'package:app/dashboard/widgets/tournament_result_preview_widget.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/placeholder_image.dart';
import 'package:app/player_profile/widgets/ranks_widget.dart';
import 'package:app/player_profile/widgets/toggle_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late TabController tabController;

class PlayerProfilePage extends ConsumerStatefulWidget {
  final PlayerProfile player;
  const PlayerProfilePage({required this.player, super.key});

  @override
  PlayerProfilePageState createState() => PlayerProfilePageState();
}

class PlayerProfilePageState extends ConsumerState<PlayerProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);

    tabController.addListener(() {
      ref.read(choiceIndex.notifier).state = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorThemeState = ref.watch(colorThemeProvider);

    return Material(
      color: colorThemeState.backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: colorThemeState.fontColor.withValues(alpha: 0.5),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Profil",
                      style: TextStyle(
                        color: colorThemeState.fontColor.withValues(alpha: 0.8),
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const PlaceholderImage(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorThemeState.fontColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.player.club,
                      style: TextStyle(
                        color: colorThemeState.fontColor.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RanksWidget(scores: widget.player.scoreData),
                  ),
                  const SizedBox(height: 32),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ToggleSwitchButton(
                      label1: "Holdkampe",
                      label2: "Turneringer",
                      enabled: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        if (widget.player.teamTournaments.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text(
                                "${widget.player.name.split(" ")[0]} har ikke spillet nogen holdkampe i den her sæson",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorThemeState.fontColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        else
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8,
                              children: [
                                const SizedBox(height: 0),
                                for (TeamTournamentResultPreview teamTournament
                                    in widget.player.teamTournaments.reversed)
                                  TeamTournamentResultPreviewWidget(
                                    result: teamTournament,
                                    width: null,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                const SizedBox(height: 0),
                              ],
                            ),
                          ),
                        if (widget.player.tournaments.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text(
                                "${widget.player.name.split(" ")[0]} har ikke spillet nogen turnerninger i den her sæson",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorThemeState.fontColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        else
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8,
                              children: [
                                const SizedBox(height: 0),
                                for (TournamentResultPreview tournament
                                    in widget.player.tournaments)
                                  TournamentResultPreviewWidget(
                                    result: tournament,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                const SizedBox(height: 0),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
