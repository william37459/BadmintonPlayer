import 'package:app/calendar/classes/season_plan_search_filter.dart';
import 'package:app/calendar/functions/get_season_plan.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/classes/tournament.dart';

Future<List<Tournament>> getUpcomingTournaments(
  List<String>? ids,
  List<String>? tournamentIds,
  SeasonPlanSearchFilter filterValues,
  String contextKey,
) async {
  List<Tournament> results = [];

  if (tournamentIds != null && tournamentIds.isNotEmpty) {
    late DateTime startDate;
    late DateTime endDate;
    late String tournamentId;

    for (String id in tournamentIds) {
      startDate = DateTime.parse(id.split('_')[0]);
      endDate = DateTime.parse(id.split('_')[1]);
      tournamentId = id.split('_')[2];
      SeasonPlanSearchFilter localFilter = filterValues.copyWith(
        startDate: startDate,
        endDate: endDate,
      );
      List<Tournament> playerResults = await getSeasonPlan(localFilter);

      playerResults.removeWhere(
        (tournament) => tournament.tournamentID.toString() != tournamentId,
      );
      results.addAll(playerResults);
    }
  }

  if (ids == null || ids.isEmpty) {
    results = await getSeasonPlan(filterValues);
  } else {
    for (String id in ids) {
      filterValues = filterValues.copyWith(player: Profile.empty(id: id));
      List<Tournament> playerResults = await getSeasonPlan(filterValues);
      results.addAll(playerResults);
    }
  }

  results = results.toSet().toList();

  return results.take(20).toList();
}
