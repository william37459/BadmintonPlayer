import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_position.dart';
import 'package:app/global/constants.dart';
import 'package:app/team_tournament_results/position/widgets/show_information_hero.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamPositionWidget extends ConsumerWidget {
  final TeamTournamentPositionTeam team;
  const TeamPositionWidget({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Hero(
      tag: team.name,
      child: SingleChildScrollView(
        child: CustomContainer(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.black.withValues(alpha: 0.5),
                barrierDismissible: true,
                pageBuilder: (BuildContext context, _, __) {
                  return InformationHero(
                    tag: team.name,
                    team: team,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              Text(
                team.position,
                style: TextStyle(
                  color: colorThemeState.fontColor.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      team.name,
                      style: TextStyle(
                        color: colorThemeState.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${team.points} points",
                      style: TextStyle(
                        color:
                            colorThemeState.primaryColor.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Icon(
                Icons.info_outline,
                color: colorThemeState.primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
