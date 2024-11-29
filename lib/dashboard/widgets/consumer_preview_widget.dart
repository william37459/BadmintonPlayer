import 'package:app/dashboard/widgets/player_preview.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ConsumerPreviewWidget extends ConsumerWidget {
  final Widget Function(dynamic props) child;
  final FutureProvider provider;
  final String errorText;
  final Axis axis;

  const ConsumerPreviewWidget({
    super.key,
    required this.child,
    required this.provider,
    required this.errorText,
    this.axis = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return Consumer(
      builder: (context, ref, _) {
        final futureAsyncValue = ref.watch(provider);
        return futureAsyncValue.when(
          error: (error, stackTrace) => Text(
            error.toString(),
          ),
          loading: () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < 10; i++)
                  Shimmer.fromColors(
                    highlightColor: Colors.grey[200] ?? Colors.grey,
                    baseColor: Colors.grey[100] ?? Colors.grey,
                    child: PlayerPreviewWidget(
                      profile: PlayerProfile(
                        name: '',
                        attachedProfiles: [],
                        club: '',
                        startLevel: '',
                        id: '',
                        scoreData: [],
                        teamTournaments: [],
                        tournaments: [],
                        seasons: {},
                      ),
                    ),
                  ),
              ],
            ),
          ),
          data: (data) {
            return data.isNotEmpty
                ? axis == Axis.horizontal
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (dynamic result in data)
                              child(
                                result,
                              ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          for (dynamic result in data)
                            child(
                              result,
                            ),
                        ],
                      )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          errorText,
                          style: TextStyle(
                            color: colorThemeState.fontColor.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }
}
