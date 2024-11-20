import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/team_tournament_club_result.dart';
import 'package:app/global/constants.dart';
import 'package:app/calendar/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MatchResultWidget extends ConsumerWidget {
  final TeamTournamentResultTeam result;

  const MatchResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return CustomContainer(
      onTap: () {
        ref.read(teamTournamentSearchFilterProvider.notifier).state =
            result.matchNumber;
        teamTournamentSearchFilterStack.add(
          result.matchNumber,
        );
        Navigator.of(context).pushNamed(
          "/TeamTournamentMatchResultPage",
          arguments: {"matchNumber": result.matchNumber.text},
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result.homeTeam.text,
                  style: TextStyle(
                    color:
                        (int.tryParse(result.result.split("-").first.trim()) ??
                                    1) >
                                (int.tryParse(
                                        result.result.split("-").last.trim()) ??
                                    1)
                            ? colorThemeState.primaryColor
                            : colorThemeState.primaryColor.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                "-",
                style: TextStyle(
                  color: colorThemeState.fontColor.withOpacity(0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    result.awayTeam.text,
                    style: TextStyle(
                      color: (int.tryParse(
                                      result.result.split("-").first.trim()) ??
                                  1) <
                              (int.tryParse(
                                      result.result.split("-").last.trim()) ??
                                  1)
                          ? colorThemeState.primaryColor
                          : colorThemeState.primaryColor.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4),
              child: Text(
                "Points",
                style: TextStyle(
                  color: colorThemeState.fontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: int.tryParse(result.points.split("-").first.trim()) ?? 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(6),
                    ),
                    color:
                        (int.tryParse(result.points.split("-").first.trim()) ??
                                    1) >
                                (int.tryParse(
                                        result.points.split("-").last.trim()) ??
                                    1)
                            ? colorThemeState.primaryColor
                            : colorThemeState.primaryColor.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      result.points.split("-").first,
                      style: TextStyle(
                        color: colorThemeState.secondaryFontColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: int.tryParse(result.points.split("-").last) ?? 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                    color:
                        (int.tryParse(result.points.split("-").first.trim()) ??
                                    1) <
                                (int.tryParse(
                                        result.points.split("-").last.trim()) ??
                                    1)
                            ? colorThemeState.primaryColor
                            : colorThemeState.primaryColor.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      result.points.split("-").last,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: colorThemeState.secondaryFontColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4),
              child: Text(
                "Resultat",
                style: TextStyle(
                  color: colorThemeState.fontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: int.tryParse(result.result.split("-").first.trim()) ?? 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(6),
                    ),
                    color:
                        (int.tryParse(result.result.split("-").first.trim()) ??
                                    1) >
                                (int.tryParse(
                                        result.result.split("-").last.trim()) ??
                                    1)
                            ? colorThemeState.primaryColor
                            : colorThemeState.primaryColor.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      result.result.split("-").first,
                      style: TextStyle(
                        color: colorThemeState.secondaryFontColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: int.tryParse(result.result.split("-").last) ?? 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                    color:
                        (int.tryParse(result.result.split("-").first.trim()) ??
                                    1) <
                                (int.tryParse(
                                        result.result.split("-").last.trim()) ??
                                    1)
                            ? colorThemeState.primaryColor
                            : colorThemeState.primaryColor.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      result.result.split("-").last,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: colorThemeState.secondaryFontColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          MatchInformationWidget(
            icon: Icons.numbers,
            text: result.matchNumber.text,
          ),
          MatchInformationWidget(
            icon: Icons.calendar_month,
            text: DateFormat('E d. MMM HH:mm', 'da_dk').format(
              convertString(result.time),
            ),
          ),
          MatchInformationWidget(
            icon: Icons.location_on_outlined,
            text: result.place,
          ),
        ],
      ),
    );
  }
}

class MatchInformationWidget extends ConsumerWidget {
  final IconData icon;
  final String text;
  const MatchInformationWidget(
      {super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: colorThemeState.fontColor.withOpacity(0.5),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: TextStyle(
              color: colorThemeState.fontColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

DateTime convertString(String text) {
  String date = text.split(" ")[1].split("‑").reversed.join("-");
  String time = text.split(" ").last;

  return DateTime.parse("$date $time:00Z");
}
//1969-07-20 20:18:04Z
