import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerResult extends ConsumerWidget {
  final Profile profile;
  final bool shouldReturnPlayer;
  const PlayerResult(
      {super.key, required this.profile, this.shouldReturnPlayer = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return InkWell(
      onTap: () {
        if (shouldReturnPlayer) {
          Navigator.pop(context, profile);
        } else {
          ref.read(selectedPlayer.notifier).state = {
            ...ref.read(selectedPlayer.notifier).state,
            "id": profile.id,
          };
          Navigator.pushNamed(
            context,
            '/PlayerProfilePage',
            arguments: {
              'name': profile.name,
              'id': profile.id,
            },
          );
        }
        //! SKAL KODES BEDRE
        // likedIdsState.contains(profile.id)
        //     ? likedIdsState.remove(profile.id)
        //     : likedIdsState.add(profile.id);
        // ref.read(likedIds.notifier).state = [...likedIdsState];
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    color: colorThemeState.primaryColor.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${profile.badmintonId}${profile.id.isNotEmpty && profile.club.isNotEmpty ? ', ' : ''}${profile.club}",
                  style: TextStyle(
                    color: colorThemeState.fontColor.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Column(
              children: [
                Icon(
                  Icons.chevron_right,
                  color: colorThemeState.primaryColor,
                ),
              ],
            ),
            // Text(profile.rankClass),
          ],
        ),
      ),
    );
  }
}
