import 'package:app/calendar/classes/season_plan_search_filter.dart';
import 'package:app/calendar/functions/get_season_plan.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/classes/settings.dart';
import 'package:app/global/classes/tournament.dart';
import 'package:app/global/constants.dart';

Future<List<Tournament>> getUpcomingTournaments(
  List<String>? ids,
  List<String>? tournamentIds,
  SeasonPlanSearchFilter filterValues,
  String contextKey,
  Settings settings,
) async {
  List<Tournament> results = [];

  if (settings.showTournamentAgeGroups.isNotEmpty) {
    for (int ageGroup in settings.showTournamentAgeGroups) {
      filterValues = filterValues.copyWith(
        ageGroupList: [
          ageGroups.firstWhere((element) => element.ageGroupId == ageGroup),
        ],
      );
      List<Tournament> ageGroupResults = await getSeasonPlan(filterValues);
      results.addAll(ageGroupResults);
    }
    filterValues = filterValues.copyWith(ageGroupList: [
        ],
      );
  }

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
    if (settings.showComingTournaments) {
      results = await getSeasonPlan(filterValues);
    }
  } else {
    for (String id in ids) {
      filterValues = filterValues.copyWith(player: Profile.empty(id: id));
      List<Tournament> playerResults = await getSeasonPlan(filterValues);
      results.addAll(playerResults);
    }
  }

  results = results.toSet().toList();

  return results.take(settings.elementsOnDashboard).toList();
}
