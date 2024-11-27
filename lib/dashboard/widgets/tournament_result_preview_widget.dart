import 'package:app/dashboard/classes/tournament_result_preview.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TournamentResultPreviewWidget extends ConsumerWidget {
  final TournamentResultPreview result;
  const TournamentResultPreviewWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorTheme = ref.watch(colorThemeProvider);

    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.organier,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat('E dd/MM', 'da_DK').format(result.date),
                style: TextStyle(
                  color: colorTheme.fontColor.withOpacity(0.6),
                ),
              ),
              Text(
                result.rank,
                style: TextStyle(
                  color: colorTheme.fontColor.withOpacity(0.6),
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
