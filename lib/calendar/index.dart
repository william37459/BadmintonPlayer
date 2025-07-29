import 'package:app/calendar/classes/season_plan_search_filter.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/tournament.dart';
import 'package:app/global/constants.dart';
import 'package:app/calendar/functions/get_season_plan.dart';
import 'package:app/calendar/functions/show_filter_modal_sheet.dart';
import 'package:app/calendar/widgets/tournament.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

StateProvider<DateTime> selectedDayProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

StateProvider<SeasonPlanSearchFilter> seasonPlanSeachFilterProvider =
    StateProvider<SeasonPlanSearchFilter>(
      (ref) => SeasonPlanSearchFilter.empty(),
    );

FutureProvider<List<Tournament>> seasonPlanFutureProvider =
    FutureProvider<List<Tournament>>((ref) async {
      SeasonPlanSearchFilter filterValues = ref.read(
        seasonPlanSeachFilterProvider,
      );
      final result = await getSeasonPlan(filterValues, contextKey);
      return result;
    });

class TournamentPlan extends ConsumerWidget {
  final TextEditingController textFieldController = TextEditingController();
  final GlobalKey<AutoCompleteTextFieldState<String>> textFieldKey =
      GlobalKey<AutoCompleteTextFieldState<String>>();
  final FocusNode textFieldFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  TournamentPlan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    DateTime selectedDay = ref.watch(selectedDayProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(seasonPlanSeachFilterProvider.notifier).state =
            SeasonPlanSearchFilter.empty();
        ref.invalidate(seasonPlanFutureProvider);
      },
      child: Scaffold(
        backgroundColor: colorThemeState.backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      "Sæsonplan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorThemeState.fontColor.withValues(alpha: 0.8),
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await showFilterModalSheet(
                          context,
                          colorThemeState,
                          ref,
                        );
                      },
                      child: Icon(
                        Icons.search,
                        color: colorThemeState.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // const ToggleSwitchButton(
              //   label1: "Sæsonplan",
              //   label2: "Turneringer",
              //   enabled: true,
              // ),
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: selectedDay,
                calendarFormat: CalendarFormat.week,
                headerVisible: true,
                locale: 'da_DK',
                headerStyle: HeaderStyle(
                  headerPadding: const EdgeInsets.only(left: 16, top: 8),
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    color: colorThemeState.fontColor,
                  ),
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  formatButtonVisible: false,
                ),
                calendarStyle: CalendarStyle(
                  selectedTextStyle: TextStyle(
                    fontSize: 14,
                    color: colorThemeState.secondaryFontColor,
                  ),
                  defaultTextStyle: TextStyle(
                    fontSize: 14,
                    color: colorThemeState.fontColor,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: colorThemeState.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: colorThemeState.primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
                selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) =>
                    ref.read(selectedDayProvider.notifier).state = selectedDay,
                onPageChanged: (focusedDay) {
                  ref.read(selectedDayProvider.notifier).state = focusedDay;
                },
              ),

              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final futureAsyncValue = ref.watch(
                      seasonPlanFutureProvider,
                    );
                    return futureAsyncValue.when(
                      error: (error, stackTrace) =>
                          Center(child: Text(error.toString())),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      data: (data) {
                        return data.isNotEmpty
                            ? ListView.builder(
                                itemCount: data
                                    .where(
                                      (tournament) =>
                                          tournament.dateTo.isAfter(
                                            selectedDay.subtract(
                                              const Duration(days: 1),
                                            ),
                                          ) &&
                                          tournament.dateFrom.isBefore(
                                            selectedDay.add(
                                              const Duration(days: 1),
                                            ),
                                          ),
                                    )
                                    .length,
                                controller: scrollController,
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemBuilder: (context, index) {
                                  data = data
                                      .where(
                                        (tournament) =>
                                            tournament.dateTo.isAfter(
                                              selectedDay.subtract(
                                                const Duration(days: 1),
                                              ),
                                            ) &&
                                            tournament.dateFrom.isBefore(
                                              selectedDay.add(
                                                const Duration(days: 1),
                                              ),
                                            ),
                                      )
                                      .toList();
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      TournamentWidget(tournament: data[index]),
                                    ],
                                  );
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Der er ingen turneringer der matchede din søgning",
                                      style: TextStyle(
                                        color: colorThemeState.fontColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Material(
                                      color: colorThemeState.primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                      child: InkWell(
                                        onTap: () {
                                          ref
                                                  .read(
                                                    seasonPlanSeachFilterProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              SeasonPlanSearchFilter.empty();
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 8.0,
                                          ),
                                          child: Text(
                                            "Nulstil filtré",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: colorThemeState
                                                  .secondaryFontColor,
                                              fontSize: 16,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
