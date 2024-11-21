import 'package:app/calendar/index.dart';
import 'package:app/calendar/widgets/custom_container.dart';
import 'package:app/dashboard/widgets/player_preview.dart';
import 'package:app/dashboard/widgets/tournament_preview.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/player_profile_search/index.dart';
import 'package:app/player_profile_search/widgets/player_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          padding: const EdgeInsets.only(bottom: 32.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Velkommen,",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          colorThemeState.secondaryFontColor.withOpacity(0.8),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Kommende turneringer',
                    style: TextStyle(
                      fontSize: 24,
                      color: colorThemeState.secondaryFontColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final futureAsyncValue =
                        ref.watch(seasonPlanFutureProvider);
                    return futureAsyncValue.when(
                      error: (error, stackTrace) => Center(
                        child: Text(
                          error.toString(),
                        ),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      data: (data) => data.isEmpty
                          ? const Text("Der er ingen kommende turneringer")
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  for (int index = 0;
                                      index < data.length;
                                      index++)
                                    TournamentPreviewWidget(
                                      tournament: data[index],
                                    ),
                                ],
                              ),
                            ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Material(
                      color: colorThemeState.secondaryFontColor,
                      borderRadius: BorderRadius.circular(4),
                      child: InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/TournamentOverviewPage'),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Se alle turneringer',
                            style: TextStyle(
                              color: colorThemeState.fontColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Favorit spillere',
            style: TextStyle(
              fontSize: 24,
              color: colorThemeState.fontColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            AsyncValue<List<Profile>> futureAsyncValue =
                ref.watch(allScoreListProvider);
            return futureAsyncValue.when(
              error: (error, stackTrace) => Text(
                error.toString(),
              ),
              loading: () => const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              data: (data) {
                return data.isEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            for (int index = 0; index < data.length; index++)
                              PlayerPreviewWidget(
                                profile: data[index],
                              ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Du har ikke nogen favorit spillere endnu",
                              style: TextStyle(
                                color:
                                    colorThemeState.fontColor.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomContainer(
                                padding: const EdgeInsets.all(0),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  child: InkWell(
                                    onTap: () =>
                                        Navigator.of(context).pushNamed(
                                      '/PlayerSearchPage',
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Tilføj spillere",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: colorThemeState.fontColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              },
            );
          },
        ),
      ],
    );
  }
}
