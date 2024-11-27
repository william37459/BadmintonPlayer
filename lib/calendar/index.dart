import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/tournament.dart';
import 'package:app/global/constants.dart';
import 'package:app/calendar/functions/get_season_plan.dart';
import 'package:app/calendar/functions/show_filter_modal_sheet.dart';
import 'package:app/calendar/widgets/custom_autofill_input.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/calendar/widgets/tournament.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

StateProvider<Map<String, dynamic>> tournamentFilterProvider =
    StateProvider<Map<String, dynamic>>(
  (ref) => {
    "ageGroupList": "",
    "classIdList": "",
    "clubIds": [],
    "firstRow": 0,
    "maxCount": 100,
    "seasonId": 2024,
  },
);

StateProvider<int> choiceIndex = StateProvider<int>((ref) => 0);

FutureProvider<List<Tournament>> seasonPlanFutureProvider =
    FutureProvider<List<Tournament>>((ref) async {
  final filterValues = ref.watch(tournamentFilterProvider);
  final result = await getSeasonPlan(filterValues, contextKey);
  return result;
});

class TorunamentPlan extends ConsumerWidget {
  final TextEditingController textFieldController = TextEditingController();
  final GlobalKey<AutoCompleteTextFieldState<String>> textFieldKey =
      GlobalKey<AutoCompleteTextFieldState<String>>();
  final FocusNode textFieldFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  TorunamentPlan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Kalender",
                style: TextStyle(
                  color: colorThemeState.secondaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // const ToggleSwitchButton(
            //   label1: "Sæsonplan",
            //   label2: "Turneringer",
            //   enabled: true,
            // ),
            CustomContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final futureAsyncValue =
                            ref.watch(seasonPlanFutureProvider);
                        return futureAsyncValue.when(
                          error: (error, stackTrace) => Center(
                            child: Text(
                              error.toString(),
                            ),
                          ),
                          loading: () => CustomAutoFill(
                            provider: tournamentFilterProvider,
                            providerKey: "clubIds",
                            hint: "Henter arrangører",
                            suggestions: const [],
                            converter: const {},
                          ),
                          data: (data) {
                            return CustomAutoFill(
                              provider: tournamentFilterProvider,
                              providerKey: "clubIds",
                              hint: "Søg efter arrangør",
                              suggestions: data.isEmpty
                                  ? []
                                  : data
                                      .map((element) => element.clubName)
                                      .toSet()
                                      .toList(),
                              converter: data.isEmpty
                                  ? {}
                                  : {
                                      for (var element in data)
                                        element.clubName.toString():
                                            element.clubID
                                    },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ref.read(isExpandedProvider.notifier).state = {};

                        for (String key
                            in ref.read(tournamentFilterProvider).keys) {
                          ref.read(isExpandedProvider.notifier).state = {
                            ...ref.read(isExpandedProvider.notifier).state,
                            key: false,
                          };
                        }

                        showFilterModalSheet(context, colorThemeState);
                      },
                      child: Icon(
                        Icons.tune,
                        size: 18,
                        color: colorThemeState.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final futureAsyncValue = ref.watch(seasonPlanFutureProvider);
                  return futureAsyncValue.when(
                    error: (error, stackTrace) => Center(
                      child: Text(
                        error.toString(),
                      ),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    data: (data) {
                      return data.isNotEmpty
                          ? ListView.builder(
                              itemCount: data.length,
                              controller: scrollController,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemBuilder: (context, index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (index == 0 ||
                                      data[index].dateFrom.month >
                                          data[index - 1].dateFrom.month)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        top: 16.0,
                                      ),
                                      child: Text(
                                        DateFormat.MMMM()
                                            .format(data[index].dateFrom),
                                        style: TextStyle(
                                          color: colorThemeState.secondaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  TournamentWidget(
                                    tournament: data[index],
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
                                    "Der er ingen turneringer der matchede din søgning",
                                    style: TextStyle(
                                      color: colorThemeState.fontColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Material(
                                    color: colorThemeState.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () {
                                        ref
                                            .read(tournamentFilterProvider
                                                .notifier)
                                            .state = {
                                          "age": null,
                                          "agegroupids": ["0"],
                                          "birthdate": null,
                                          "classids": ["0"],
                                          "clubid": "",
                                          "disciplines": null,
                                          "gender": "",
                                          "georegionids": null,
                                          "page": 0,
                                          "playerid": "",
                                          "points": null,
                                          "publicseasonplan": true,
                                          "regionids": null,
                                          "seasonid": "2023",
                                          "selectclientfunction": null,
                                          "showleague": true,
                                          "strfrom": "",
                                          "strto": "",
                                          "strweekno": "",
                                          "strweekno2": "",
                                        };
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
    );
  }
}
