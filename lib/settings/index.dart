import 'package:app/dashboard/widgets/tournament_preview.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/settings.dart';
import 'package:app/global/classes/tournament.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

StateProvider<Settings> settingsProvider = StateProvider<Settings>(
  (ref) => Settings.empty(),
);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    Settings settingsState = ref.watch(settingsProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
        await asyncPrefs.setStringList(
          'settings',
          settingsState.toStringList(),
        );
      },
      child: Material(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: colorThemeState.backgroundColor,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            color: colorThemeState.fontColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Indstillinger",
                            style: TextStyle(
                              color: colorThemeState.fontColor.withValues(
                                alpha: 0.8,
                              ),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Opacity(
                          opacity: 0,
                          child: Icon(Icons.chevron_left),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Udseende",
                      style: TextStyle(
                        color: colorThemeState.fontColor.withValues(alpha: 0.8),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Mørk tilstand",
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                              ),
                            ),
                            Switch.adaptive(
                              value: settingsState.darkMode,
                              activeColor: colorThemeState.primaryColor,
                              onChanged: (value) {
                                ref
                                    .read(colorThemeProvider.notifier)
                                    .state = value
                                    ? CustomColorTheme.dark()
                                    : CustomColorTheme.light();
                                ref.read(settingsProvider.notifier).state =
                                    settingsState.copyWith(darkMode: value);
                              },
                            ),
                          ],
                        ),
                        Divider(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.1,
                          ),
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Naturlig tidsangivelse",
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                              ),
                            ),
                            Switch.adaptive(
                              value: settingsState.naturaltime,
                              activeColor: colorThemeState.primaryColor,
                              onChanged: (value) {
                                ref.read(settingsProvider.notifier).state =
                                    settingsState.copyWith(naturaltime: value);
                              },
                            ),
                          ],
                        ),
                        Divider(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.1,
                          ),
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Stjerne ved favorit turneringer",
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                              ),
                            ),
                            Switch.adaptive(
                              value: settingsState.starAtFavourites,
                              activeColor: colorThemeState.primaryColor,
                              onChanged: (value) {
                                ref
                                    .read(settingsProvider.notifier)
                                    .state = settingsState.copyWith(
                                  starAtFavourites: value,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: IgnorePointer(
                      child: TournamentPreviewWidget(
                        tournament: Tournament.empty(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Dashboard",
                      style: TextStyle(
                        color: colorThemeState.fontColor.withValues(alpha: 0.8),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Antal turneringer og resultater (${settingsState.elementsOnDashboard})",
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                              ),
                            ),

                            Slider.adaptive(
                              value: settingsState.elementsOnDashboard
                                  .toDouble(),
                              min: 10,
                              max: 50,
                              activeColor: colorThemeState.primaryColor,
                              onChanged: (value) =>
                                  ref
                                      .read(settingsProvider.notifier)
                                      .state = settingsState.copyWith(
                                    elementsOnDashboard: value.toInt(),
                                  ),
                            ),
                          ],
                        ),
                        Divider(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.1,
                          ),
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vis fulgte turneringer",
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                              ),
                            ),
                            Switch.adaptive(
                              value: settingsState.showFollowedTournaments,
                              activeColor: colorThemeState.primaryColor,
                              onChanged: (value) {
                                ref
                                    .read(settingsProvider.notifier)
                                    .state = settingsState.copyWith(
                                  showFollowedTournaments: value,
                                );
                              },
                            ),
                          ],
                        ),
                        Divider(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.1,
                          ),
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vis turneringer for fulgte spillere",
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                              ),
                            ),
                            Switch.adaptive(
                              value: settingsState
                                  .showTournamentsForFollowedPlayers,
                              activeColor: colorThemeState.primaryColor,
                              onChanged: (value) {
                                ref
                                    .read(settingsProvider.notifier)
                                    .state = settingsState.copyWith(
                                  showTournamentsForFollowedPlayers: value,
                                );
                              },
                            ),
                          ],
                        ),
                        Divider(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.1,
                          ),
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vis alle kommende turneringer",
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                              ),
                            ),
                            Switch.adaptive(
                              value: settingsState.showComingTournaments,
                              activeColor: colorThemeState.primaryColor,
                              onChanged: (value) {
                                ref
                                    .read(settingsProvider.notifier)
                                    .state = settingsState.copyWith(
                                  showComingTournaments: value,
                                );
                              },
                            ),
                          ],
                        ),
                        Divider(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.1,
                          ),
                          height: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Vis turneringer for aldersgrupper",
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: ageGroups
                                  .map(
                                    (ageGroup) => AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 150,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            settingsState
                                                .showTournamentAgeGroups
                                                .contains(ageGroup.ageGroupId)
                                            ? colorThemeState.primaryColor
                                            : colorThemeState.backgroundColor,
                                        border: Border.all(
                                          color:
                                              settingsState
                                                  .showTournamentAgeGroups
                                                  .contains(ageGroup.ageGroupId)
                                              ? colorThemeState.primaryColor
                                              : colorThemeState.fontColor
                                                    .withValues(alpha: 0.2),
                                        ),
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(48),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            48,
                                          ),
                                          onTap: () =>
                                              ref
                                                  .read(
                                                    settingsProvider.notifier,
                                                  )
                                                  .state = settingsState.copyWith(
                                                showTournamentAgeGroups:
                                                    settingsState
                                                        .showTournamentAgeGroups
                                                        .contains(
                                                          ageGroup.ageGroupId,
                                                        )
                                                    ? (settingsState
                                                          .showTournamentAgeGroups
                                                        ..remove(
                                                          ageGroup.ageGroupId,
                                                        ))
                                                    : (settingsState
                                                          .showTournamentAgeGroups
                                                        ..add(
                                                          ageGroup.ageGroupId,
                                                        )),
                                              ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            child: Text(
                                              ageGroup.ageGroupName,
                                              style: TextStyle(
                                                color:
                                                    settingsState
                                                        .showTournamentAgeGroups
                                                        .contains(
                                                          ageGroup.ageGroupId,
                                                        )
                                                    ? Colors.white
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
