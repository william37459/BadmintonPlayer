import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/modal_bottom_sheet.dart';
import 'package:app/player_profile_search/functions/get_profiles.dart';
import 'package:app/player_profile_search/widgets/player_result.dart';
import 'package:app/calendar/widgets/custom_autofill_input.dart';
import 'package:app/calendar/widgets/custom_expander.dart';
import 'package:app/calendar/widgets/custom_input.dart';
import 'package:app/calendar/widgets/wrapper_selector.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Map<String, dynamic>> profileFilterProvider =
    StateProvider<Map<String, dynamic>>(
  (ref) => {
    "callbackcontextkey": contextKey,
    "selectfunction": "SPSel1",
    "name": "",
    "clubid": "",
    "playernumber": "",
    "gender": "",
    "agegroupid": "",
    "searchteam": false,
    "licenseonly": false,
    "agegroupcontext": 0,
    "tournamentdate": ""
  },
);

FutureProvider<List<Profile>> allScoreListProvider =
    FutureProvider<List<Profile>>((ref) async {
  final filter = ref.watch(profileFilterProvider);
  final result = await getProfiles(filter);
  return result;
});

class PlayerSearch extends ConsumerWidget {
  final TextEditingController textFieldController = TextEditingController();
  final GlobalKey<AutoCompleteTextFieldState<String>> textFieldKey =
      GlobalKey<AutoCompleteTextFieldState<String>>();

  final FocusNode textFieldFocusNode = FocusNode();

  final bool shuldReturnPlayer;

  PlayerSearch({super.key, this.shuldReturnPlayer = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profil Søgning",
                    style: TextStyle(
                      color: colorThemeState.secondaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: textFieldFocusNode,
                      key: textFieldKey,
                      controller: textFieldController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(4),
                        isDense: true,
                        isCollapsed: true,
                        hintText: "Søg efter spiller",
                      ),
                      onChanged: (value) =>
                          ref.read(profileFilterProvider.notifier).state = {
                        ...ref.read(profileFilterProvider.notifier).state,
                        "name": value,
                      },
                      onSubmitted: (data) {
                        if (data.isEmpty) {
                          ref.read(profileFilterProvider.notifier).state = {
                            ...ref.read(profileFilterProvider.notifier).state,
                            "name": data,
                          };
                        }
                      },
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          ref.read(isExpandedProvider.notifier).state = {};

                          for (String key
                              in ref.read(profileFilterProvider).keys) {
                            ref.read(isExpandedProvider.notifier).state = {
                              ...ref.read(isExpandedProvider.notifier).state,
                              key: false,
                            };
                          }
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => FilterBottomSheet(
                              children: [
                                CustomExpander(
                                  isExpandedKey: "clubid",
                                  header: Text(
                                    "Klub",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: CustomAutoFill(
                                    provider: profileFilterProvider,
                                    hint: "Søg efter klub",
                                    providerKey: "clubid",
                                    suggestions: clubs
                                        .map((e) => e.fullClubName)
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "playernumber",
                                  header: Text(
                                    "BadmintonID",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: CustomInput(
                                    provider: profileFilterProvider,
                                    hint: "Søg efter BadmintonID",
                                    providerKey: "playernumber",
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "agegroupid",
                                  header: Text(
                                    "Årgang",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: WrapperSelector(
                                    data: profileSearchFilters['agegroupid'] ??
                                        {},
                                    providerKey: "agegroupid",
                                    provider: profileFilterProvider,
                                    isMultiSelect: false,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomExpander(
                                  isExpandedKey: "gender",
                                  header: Text(
                                    "Køn",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: colorThemeState.secondaryColor,
                                    ),
                                  ),
                                  body: WrapperSelector(
                                    data: profileSearchFilters['gender'] ?? {},
                                    providerKey: "gender",
                                    provider: profileFilterProvider,
                                    isMultiSelect: false,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.tune,
                          size: 18,
                          color: colorThemeState.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
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
                    return data.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemBuilder: (context, index) => PlayerResult(
                                profile: data[index],
                                shouldReturnPlayer: shuldReturnPlayer,
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Der er ingen spillere der matchede din søgning",
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
                                            .read(
                                                profileFilterProvider.notifier)
                                            .state = {
                                          "callbackcontextkey": contextKey,
                                          "selectfunction": "SPSel1",
                                          "name": "",
                                          "clubid": "",
                                          "playernumber": "",
                                          "gender": "",
                                          "agegroupid": "",
                                          "searchteam": false,
                                          "licenseonly": false,
                                          "agegroupcontext": 0,
                                          "tournamentdate": ""
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
                            ),
                          );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
