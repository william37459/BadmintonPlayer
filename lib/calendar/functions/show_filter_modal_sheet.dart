import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/modal_bottom_sheet.dart';
import 'package:app/player_profile_search/index.dart';
import 'package:app/calendar/index.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/calendar/widgets/custom_date_picker.dart';
import 'package:app/calendar/widgets/custom_input.dart';
import 'package:app/calendar/widgets/drop_down_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showFilterModalSheet(
  BuildContext context,
  CustomColorTheme colorThemeState,
  WidgetRef ref,
) {
  final StateProvider<Profile?> selectedPlayer =
      StateProvider<Profile?>((ref) => null);
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => FilterBottomSheet(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Sæson",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
        ),
        CustomContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CustomDropDownSelector(
            data: {
              for (var element in seasonPlanSearchFilters['seasons'] ?? [])
                element.seasonId.toString(): element.name
            },
            onChanged: (value) {
              ref.read(tournamentFilterProvider.notifier).state = {
                ...ref.read(tournamentFilterProvider.notifier).state,
                "seasonid": value,
              };
            },
            initalValue: "Vælg sæson",
            hint: "Vælg sæson",
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Årgang",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
        ),
        CustomContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CustomDropDownSelector(
            data: {
              for (var element in seasonPlanSearchFilters['ageGroups'] ?? [])
                element.ageGroupId.toString(): element.ageGroupName
            },
            onChanged: (value) {
              ref.read(tournamentFilterProvider.notifier).state = {
                ...ref.read(tournamentFilterProvider.notifier).state,
                "agegroupid": value,
              };
            },
            initalValue: "Vælg årgang",
            hint: "Årgang",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Række",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
        ),
        CustomContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CustomDropDownSelector(
            data: {
              for (var element in seasonPlanSearchFilters['class'] ?? [])
                element.classID.toString(): element.className
            },
            onChanged: (value) {
              ref.read(tournamentFilterProvider.notifier).state = {
                ...ref.read(tournamentFilterProvider.notifier).state,
                "classid": value,
              };
            },
            initalValue: "Vælg række",
            hint: "Række",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Dato",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: CustomDatePicker(
                  providerKey: "dateFrom",
                  provider: tournamentFilterProvider,
                  hintText: "Start dato",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: colorThemeState.primaryColor,
                ),
              ),
              Expanded(
                child: CustomDatePicker(
                  providerKey: "dateTo",
                  provider: tournamentFilterProvider,
                  hintText: "Slut dato",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Uge",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: CustomInput(
                hint: "Start uge",
                providerKey: "strweekno",
                provider: tournamentFilterProvider,
                inputType: TextInputType.number,
                min: 1,
                max: 53,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
              ),
              child: Icon(
                Icons.more_horiz,
                color: colorThemeState.primaryColor,
              ),
            ),
            Expanded(
              child: CustomInput(
                min: 1,
                max: 53,
                hint: "Slut uge",
                providerKey: "strweekno2",
                provider: tournamentFilterProvider,
                inputType: TextInputType.number,
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Område",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
        ),
        CustomContainer(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(
            8.0,
          ),
          child: CustomDropDownSelector(
            data: {
              for (var element in seasonPlanSearchFilters['geoRegions'] ?? [])
                element.geoRegionID.toString(): element.name
            },
            onChanged: (value) {
              ref.read(tournamentFilterProvider.notifier).state = {
                ...ref.read(tournamentFilterProvider.notifier).state,
                "georegionid": value,
              };
            },
            initalValue: "Vælg område",
            hint: "Område",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Turneringer i din egn",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorThemeState.secondaryColor,
            ),
          ),
        ),
        CustomContainer(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(
            8.0,
          ),
          child: CustomDropDownSelector(
            data: {
              for (var element in seasonPlanSearchFilters['regions'] ?? [])
                element.regionId.toString(): element.name
            },
            onChanged: (value) {
              ref.read(tournamentFilterProvider.notifier).state = {
                ...ref.read(tournamentFilterProvider.notifier).state,
                "regionids": value,
              };
            },
            initalValue: "Vælg område",
            hint: "Turneringer i din egn",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Consumer(
          builder: (context, ref, child) {
            final birthdate = ref.watch(
              tournamentFilterProvider.select(
                (value) => value['birthdate'],
              ),
            );
            final age = ref.watch(
              tournamentFilterProvider.select(
                (value) => value['age'],
              ),
            );
            final gender = ref.watch(
              tournamentFilterProvider.select(
                (value) => value['gender'],
              ),
            );
            final points = ref.watch(
              tournamentFilterProvider.select(
                (value) => value['points'],
              ),
            );

            return AnimatedOpacity(
              opacity: (birthdate != null && birthdate.isNotEmpty) ||
                      (age != null && age.isNotEmpty) ||
                      (gender != null && gender.isNotEmpty) ||
                      (points != null && points.isNotEmpty)
                  ? 0.5
                  : 1,
              duration: const Duration(milliseconds: 250),
              child: AbsorbPointer(
                absorbing: (birthdate != null && birthdate.isNotEmpty) ||
                    (age != null && age.isNotEmpty) ||
                    (gender != null && gender.isNotEmpty) ||
                    (points != null && points.isNotEmpty),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Spiller",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: colorThemeState.secondaryColor,
                        ),
                      ),
                    ),
                    CustomContainer(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 2,
                      ),
                      onTap: () async {
                        Profile? value = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PlayerSearch(),
                          ),
                        );
                        ref.read(selectedPlayer.notifier).state = value;
                        ref.read(tournamentFilterProvider.notifier).state = {
                          ...ref.read(tournamentFilterProvider.notifier).state,
                          "playerid": value?.id ?? "",
                        };
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              Profile? selectedProfileState =
                                  ref.watch(selectedPlayer);
                              return Text(
                                selectedProfileState?.name ?? "",
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {
                              ref.read(selectedPlayer.notifier).state = null;
                              ref
                                  .read(tournamentFilterProvider.notifier)
                                  .state = {
                                ...ref
                                    .read(tournamentFilterProvider.notifier)
                                    .state,
                                "playerid": "",
                              };
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Consumer(builder: (context, ref, child) {
          final playerid = ref.watch(
            tournamentFilterProvider.select(
              (value) => value['playerid'],
            ),
          );
          return AnimatedOpacity(
            opacity: playerid != null && playerid.isNotEmpty ? 0.5 : 1,
            duration: const Duration(milliseconds: 250),
            child: AbsorbPointer(
              absorbing: playerid != null && playerid.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Fødselsdato",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: colorThemeState.secondaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomDatePicker(
                      providerKey: "birthdate",
                      provider: tournamentFilterProvider,
                      hintText: "Fødselsdag",
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Alder",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: colorThemeState.secondaryColor,
                      ),
                    ),
                  ),
                  CustomContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomInput(
                      providerKey: "age",
                      provider: tournamentFilterProvider,
                      hint: "Alder",
                      inputType: TextInputType.number,
                      min: 0,
                      max: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Point",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: colorThemeState.secondaryColor,
                      ),
                    ),
                  ),
                  CustomContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomInput(
                      providerKey: "points",
                      provider: tournamentFilterProvider,
                      hint: "Point",
                      inputType: TextInputType.number,
                      min: 0,
                      max: 10000,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ),
  );
}
