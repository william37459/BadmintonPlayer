import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:app/dashboard/classes/tournament_result_preview.dart';
import 'package:app/dashboard/widgets/team_tournament_result_preview.dart';
import 'package:app/dashboard/widgets/tournament_result_preview_widget.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/player_profile/widgets/ranks_widget.dart';
import 'package:app/player_profile/widgets/toggle_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late TabController tabController;

class PlayerProfilePage extends ConsumerStatefulWidget {
  final PlayerProfile player;
  const PlayerProfilePage({
    required this.player,
    super.key,
  });

  @override
  PlayerProfilePageState createState() => PlayerProfilePageState();
}

class PlayerProfilePageState extends ConsumerState<PlayerProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);

    tabController.addListener(
      () {
        ref.read(choiceIndex.notifier).state = tabController.index;
      },
    );
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
                horizontal: 16,
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
                    "Profil",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorThemeState.fontColor.withValues(alpha: 0.8),
                      fontSize: 16,
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                    ),
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
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RanksWidget(scores: widget.player.scoreData),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ToggleSwitchButton(
                      label1: "Holdkampe",
                      label2: "Turneringer",
                      enabled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              const SizedBox(
                                height: 0,
                              ),
                              for (TeamTournamentResultPreview teamTournament
                                  in widget.player.teamTournaments.reversed)
                                TeamTournamentResultPreviewWidget(
                                  result: teamTournament,
                                  width: null,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                              const SizedBox(
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              const SizedBox(
                                height: 0,
                              ),
                              for (TournamentResultPreview tournament
                                  in widget.player.tournaments)
                                TournamentResultPreviewWidget(
                                  result: tournament,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                              const SizedBox(
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
