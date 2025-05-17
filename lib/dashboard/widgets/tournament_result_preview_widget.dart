import 'package:app/dashboard/classes/tournament_result_preview.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/tournament_result_page/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TournamentResultPreviewWidget extends ConsumerWidget {
  final TournamentResultPreview result;
  final EdgeInsets margin;

  const TournamentResultPreviewWidget({
    super.key,
    required this.result,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorTheme = ref.watch(colorThemeProvider);

    return CustomContainer(
      onTap: () {
        ref.read(tournamentResultFilterProvider.notifier).state = {
          "clientselectfunction": "SelectTournamentClass1",
          "clubid": 0,
          "groupnumber": 0,
          "locationnumber": 0,
          "playerid": 0,
          "tabnumber": 0,
          "tournamenteventid": 451551,
        };

        ref.read(selectedTournament.notifier).state = result.id;

        Navigator.of(context).pushNamed('/TournamentResultPage', arguments: {
          'tournament': result.organiser,
        });
      },
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.organiser,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat('E dd/MM', 'da_DK').format(result.date),
                style: TextStyle(
                  color: colorTheme.fontColor.withValues(alpha: 0.6),
                ),
              ),
              Text(
                result.rank,
                style: TextStyle(
                  color: colorTheme.fontColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: colorTheme.primaryColor,
          )
        ],
      ),
    );
  }
}
