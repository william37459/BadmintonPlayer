import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerPreviewWidget extends ConsumerWidget {
  final PlayerProfile profile;

  const PlayerPreviewWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomContainer(
      width: 200,
      onTap: () {
        ref.read(selectedPlayer.notifier).state = profile.id;
        Navigator.of(context).pushNamed(
          "/PlayerProfilePage",
        );
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
              "https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    profile.club,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    profile.startLevel.isEmpty
                        ? "Ingen rangering"
                        : "#${profile.startLevel}",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
