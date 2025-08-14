import 'package:app/global/widgets/custom_date_picker.dart';
import 'package:app/global/widgets/custom_expander.dart';
import 'package:app/global/widgets/custom_input.dart';
import 'package:app/global/widgets/wrapper_selector.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/global/widgets/modal_bottom_sheet.dart';
import 'package:app/player_profile_search/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showFilterModalSheet(
  BuildContext context,
  Map<String, dynamic> rankSearchFilters,
  CustomColorTheme colorThemeState,
  StateProvider<Map<String, dynamic>> rankFilterProvider,
  WidgetRef ref,
) {
  final StateProvider<Profile?> selectedPlayer = StateProvider<Profile?>(
    (ref) => null,
  );

  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => FilterBottomSheet(
      children: [
        // CustomExpander(
        //   isExpandedKey: "seasonid",
        //   header: Text(
        //     "Sæson",
        //     style: TextStyle(
        //       fontSize: 24,
        //       fontWeight: FontWeight.w600,
        //       color: colorThemeState.secondaryColor,
        //     ),
        //   ),
        //   body: CustomDropDownSelector(
        //     data: rankSearchFilters['season'] ?? {},
        //     onChanged: (value) {
        //       ref.read(rankFilterProvider.notifier).state = {
        //         ...ref.read(rankFilterProvider.notifier).state,
        //         "seasonid": value,
        //       };
        //     },
        //     initalValue: "Vælg sæson",
        //     hint: "Vælg sæson",
        //   ),
        // ),
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
            data: rankSearchFilters['ageGroup'] ?? {},
            providerKey: "agegroupid",
            provider: rankFilterProvider,
            isMultiSelect: false,
          ),
        ),
        const SizedBox(height: 16),
        CustomExpander(
          isExpandedKey: "classid",
          header: Text(
            "Række",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
          body: WrapperSelector(
            data: rankSearchFilters['class'] ?? {},
            providerKey: "classid",
            provider: rankFilterProvider,
            isMultiSelect: false,
          ),
        ),
        const SizedBox(height: 16),
        // CustomExpander(
        //   isExpandedKey: "regionid",
        //   header: Text(
        //     "Kreds/Landsdel",
        //     style: TextStyle(
        //       fontSize: 24,
        //       fontWeight: FontWeight.w600,
        //       color: colorThemeState.secondaryColor,
        //     ),
        //   ),
        //   body: CustomDropDownSelector(
        //     data: rankSearchFilters['geoRegions'] ?? {},
        //     onChanged: (value) {
        //       ref.read(rankFilterProvider.notifier).state = {
        //         ...ref.read(rankFilterProvider.notifier).state,
        //         "regionid": value,
        //       };
        //     },
        //     initalValue: "Vælg kreds eller landsdel",
        //     hint: "Vælg kreds eller landsdel",
        //   ),
        // ),
        const SizedBox(height: 16),
        CustomExpander(
          isExpandedKey: "playerid",
          header: Text(
            "Spiller",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
          body: CustomContainer(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            onTap: () async {
              Profile? value = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const PlayerSearch(shouldReturnPlayer: true),
                ),
              );

              ref.read(selectedPlayer.notifier).state = value;
              // ref
              ref.read(rankFilterProvider.notifier).state = {
                ...ref.read(rankFilterProvider.notifier).state,
                "playerid": value?.id ?? "",
              };
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    Profile? selectedProfileState = ref.watch(selectedPlayer);
                    return Text(selectedProfileState?.name ?? "");
                  },
                ),
                InkWell(
                  onTap: () {
                    ref.read(selectedPlayer.notifier).state = null;
                    ref.read(rankFilterProvider.notifier).state = {
                      ...ref.read(rankFilterProvider.notifier).state,
                      "playerid": "",
                    };
                  },
                  child: const Icon(Icons.clear, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomExpander(
          isExpandedKey: "pointsfrom",
          header: Text(
            "Point",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
          body: Row(
            children: [
              Expanded(
                child: CustomInput(
                  hint: "Minimum point",
                  providerKey: "pointsfrom",
                  provider: rankFilterProvider,
                  inputType: TextInputType.number,
                  min: 0,
                  max: 10000,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(
                  Icons.more_horiz,
                  color: colorThemeState.primaryColor,
                ),
              ),
              Expanded(
                child: CustomInput(
                  min: 0,
                  max: 10000,
                  hint: "Max point",
                  providerKey: "pointsto",
                  provider: rankFilterProvider,
                  inputType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomExpander(
          isExpandedKey: "rankingfrom",
          header: Text(
            "Placering",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
          body: Row(
            children: [
              Expanded(
                child: CustomInput(
                  hint: "Minimum placering",
                  providerKey: "rankingfrom",
                  provider: rankFilterProvider,
                  inputType: TextInputType.number,
                  min: 0,
                  max: 10000,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(
                  Icons.more_horiz,
                  color: colorThemeState.primaryColor,
                ),
              ),
              Expanded(
                child: CustomInput(
                  min: 0,
                  max: 10000,
                  hint: "Max placering",
                  providerKey: "rankingto",
                  provider: rankFilterProvider,
                  inputType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomExpander(
          isExpandedKey: "birthdatefromstring",
          header: Text(
            "Fødselsdato",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
          body: Row(
            children: [
              Expanded(
                child: CustomDatePicker(
                  hintText: "Fødselsdag fra",
                  providerKey: "birthdatefromstring",
                  provider: rankFilterProvider,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(
                  Icons.more_horiz,
                  color: colorThemeState.primaryColor,
                ),
              ),
              Expanded(
                child: CustomDatePicker(
                  hintText: "Fødselsdag til",
                  providerKey: "birthdatetostring",
                  provider: rankFilterProvider,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
