import 'dart:math';

import 'package:app/global/classes/club.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/drop_down_selector.dart';
import 'package:app/global/widgets/modal_bottom_sheet.dart';
import 'package:app/player_profile_search/functions/get_profiles.dart';
import 'package:app/player_profile_search/widgets/player_result.dart';
import 'package:app/global/widgets/custom_expander.dart';
import 'package:app/global/widgets/custom_input.dart';
import 'package:app/global/widgets/wrapper_selector.dart';
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
        "tournamentdate": "",
      },
    );

FutureProvider<List<Profile>> allScoreListProvider =
    FutureProvider<List<Profile>>((ref) async {
      final filter = ref.watch(profileFilterProvider);
      final result = await getProfiles(filter);
      return result;
    });

class PlayerSearch extends ConsumerStatefulWidget {
  final bool shouldReturnPlayer;
  final bool favouriteMode;

  const PlayerSearch({
    super.key,
    this.shouldReturnPlayer = false,
    this.favouriteMode = false,
  });

  @override
  ConsumerState<PlayerSearch> createState() => _PlayerSearchState();
}

class _PlayerSearchState extends ConsumerState<PlayerSearch> {
  late TextEditingController textFieldController;
  final GlobalKey<AutoCompleteTextFieldState<String>> textFieldKey =
      GlobalKey<AutoCompleteTextFieldState<String>>();
  late FocusNode textFieldFocusNode;

  @override
  void initState() {
    super.initState();
    textFieldController = TextEditingController();
    textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Scaffold(
      backgroundColor: colorThemeState.backgroundColor,
      floatingActionButton: widget.shouldReturnPlayer
          ? null
          : FloatingActionButton.extended(
              backgroundColor: colorThemeState.primaryColor,
              icon: Icon(Icons.save, color: colorThemeState.secondaryFontColor),
              label: Text(
                "Færdig",
                style: TextStyle(
                  color: colorThemeState.secondaryFontColor,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(profileFilterProvider.notifier).state = {
                  ...ref.read(profileFilterProvider.notifier).state,
                  "name": "",
                };
              },
            ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profil Søgning",
                    style: TextStyle(
                      color: colorThemeState.fontColor.withValues(alpha: 0.8),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffEBEBEB),
                borderRadius: BorderRadius.circular(42),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
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
                                  body: CustomDropDownSelector<Club>(
                                    itemAsString: (item) => (item).clubName,
                                    items: (filter, props) => clubs,
                                    compareFn: (item1, item2) =>
                                        (item1).clubName == (item2).clubName,
                                    hint: "Søg efter klub",
                                    initalValue: null,
                                    onChanged: (item) {
                                      ref
                                          .read(profileFilterProvider.notifier)
                                          .state = {
                                        ...ref.read(profileFilterProvider),
                                        "clubID": item.clubId.toString(),
                                      };
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
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
                                const SizedBox(height: 16),
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
                                    data:
                                        profileSearchFilters['agegroupid'] ??
                                        {},
                                    providerKey: "agegroupid",
                                    provider: profileFilterProvider,
                                    isMultiSelect: false,
                                  ),
                                ),
                                const SizedBox(height: 16),
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
                          color: colorThemeState.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                AsyncValue<List<Profile>> futureAsyncValue = ref.watch(
                  allScoreListProvider,
                );
                return futureAsyncValue.when(
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  data: (data) {
                    return data.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: min(data.length, 25),
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemBuilder: (context, index) => PlayerResult(
                                profile: data[index],
                                shouldReturnPlayer: widget.shouldReturnPlayer,
                                favouriteMode: widget.favouriteMode,
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
                                  const SizedBox(height: 16),
                                  Material(
                                    color: colorThemeState.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () {
                                        ref
                                            .read(
                                              profileFilterProvider.notifier,
                                            )
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
                                          "tournamentdate": "",
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
