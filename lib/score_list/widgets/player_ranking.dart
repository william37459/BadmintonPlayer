import 'package:app/dashboard/functions/get_player_profile_preview.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/classes/player_score.dart';
import 'package:app/global/constants.dart';
// import 'package:app/score_list/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerRanking extends ConsumerWidget {
  final PlayerScore playerScore;
  const PlayerRanking({super.key, required this.playerScore});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return InkWell(
      onTap: () async {
        NavigatorState navigatorState = Navigator.of(context);

        showDialog(
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );

        PlayerProfile? selectedPlayer = await getPlayerProfilePreview(
          playerScore.id,
          contextKey,
          ref,
        );

        navigatorState.pop();

        navigatorState.pushNamed(
          '/PlayerProfilePage',
          arguments: {'player': selectedPlayer},
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Text(
                  playerScore.rank.padLeft(3, ' '),
                  style: TextStyle(
                    color: colorThemeState.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerScore.name,
                        style: TextStyle(
                          color: colorThemeState.fontColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${playerScore.rankClass}${playerScore.rankClass.isNotEmpty && playerScore.points != null ? ', ' : ''}${playerScore.points == null ? '' : '${playerScore.points} point'}",
                        style: TextStyle(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Column(
                  children: [
                    Icon(
                      Icons.chevron_right,
                      color: colorThemeState.fontColor.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                // Text(playerScore.rankClass),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: colorThemeState.fontColor.withValues(alpha: 0.5),
              borderRadius: BorderRadiusDirectional.circular(2),
            ),
            height: 0.25,
          ),
        ],
      ),
    );
  }
}

class CustomCircularProgressIndicator extends StatefulWidget {
  final Color? color;
  const CustomCircularProgressIndicator({super.key, this.color});

  @override
  State<CustomCircularProgressIndicator> createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      upperBound: 1,
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: controller,
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FractionallySizedBox(
                widthFactor: 0.25,
                child: Image.asset(
                  "assets/Foreground.png",
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
