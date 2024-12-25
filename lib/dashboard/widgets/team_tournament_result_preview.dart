import 'package:app/global/widgets/custom_container.dart';
import 'package:app/dashboard/classes/team_tournament_result_preview.dart';
import 'package:flutter/material.dart';

class TeamTournamentResultPreviewWidget extends StatelessWidget {
  final TeamTournamentResultPreview result;
  final double? width;
  final EdgeInsets margin;

  const TeamTournamentResultPreviewWidget({
    super.key,
    required this.result,
    this.width = 300,
    this.margin = const EdgeInsets.symmetric(horizontal: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: width,
      margin: margin,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    result.league,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    "#${result.matchNumber}",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 1,
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8,
            ),
            child: Column(
              children: [
                Opacity(
                  opacity:
                      result.homeTeam.result > result.awayTeam.result ? 1 : 0.6,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.homeTeam.name,
                        ),
                      ),
                      Text(
                        result.homeTeam.result.toString(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Opacity(
                  opacity:
                      result.homeTeam.result < result.awayTeam.result ? 1 : 0.6,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.awayTeam.name,
                        ),
                      ),
                      Text(
                        result.awayTeam.result.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
