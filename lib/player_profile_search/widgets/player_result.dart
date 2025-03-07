import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerResult extends ConsumerWidget {
  final Profile profile;
  final bool shouldReturnPlayer;
  final bool favouriteMode;
  const PlayerResult({
    super.key,
    required this.profile,
    this.shouldReturnPlayer = false,
    this.favouriteMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    List<String> favouritePlayersState = ref.watch(favouritePlayers) ?? [];
    return Column(
      children: [
        InkWell(
          onTap: () async {
            if (shouldReturnPlayer) {
              Navigator.pop(context, profile);
            } else if (favouriteMode) {
              if (favouritePlayersState.contains(profile.id)) {
                ref.read(favouritePlayers.notifier).state = [
                  ...favouritePlayersState
                      .where((element) => element != profile.id),
                ];
              } else {
                ref.read(favouritePlayers.notifier).state = [
                  ...favouritePlayersState,
                  profile.id,
                ];
              }
              final SharedPreferencesAsync asyncPrefs =
                  SharedPreferencesAsync();
              await asyncPrefs.setStringList(
                'favouritePlayers',
                ref.read(favouritePlayers.notifier).state ?? [],
              );
            } else {
              ref.read(selectedPlayer.notifier).state = profile.id;
              // Navigator.pushNamed(
              //   context,
              //   '/PlayerProfilePage',
              //   arguments: {
              //     'name': profile.name,
              //     'id': profile.id,
              //   },
              // );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                if (favouriteMode)
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    firstChild: Icon(
                      Icons.star_rounded,
                      color:
                          colorThemeState.primaryColor.withValues(alpha: 0.8),
                      size: 32,
                    ),
                    secondChild: Icon(
                      Icons.star_outline_rounded,
                      color: colorThemeState.fontColor.withValues(alpha: 0.3),
                      size: 32,
                    ),
                    crossFadeState: favouritePlayersState.contains(profile.id)
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                if (favouriteMode) const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: TextStyle(
                        color: colorThemeState.fontColor,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${profile.badmintonId}${profile.id.isNotEmpty && profile.club.isNotEmpty ? ', ' : ''}${profile.club}",
                      style: TextStyle(
                        color: colorThemeState.fontColor.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(),
                ),
                if (!favouriteMode)
                  Icon(
                    Icons.chevron_right,
                    color: colorThemeState.primaryColor,
                  ),
                // Text(profile.rankClass),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: colorThemeState.fontColor.withValues(alpha: 0.5),
            borderRadius: BorderRadiusDirectional.circular(2),
          ),
          height: 0.25,
        ),
      ],
    );
  }
}
