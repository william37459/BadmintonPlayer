import 'package:app/global/classes/club.dart';
import 'package:app/global/classes/profile.dart';
import 'package:app/global/classes/search_filters/age_group.dart';
import 'package:app/global/classes/search_filters/class_group.dart';
import 'package:app/global/classes/search_filters/region.dart';
import 'package:app/global/classes/search_filters/seasons.dart';

class SeasonPlanSearchFilter {
  final Season season;
  final List<AgeGroup> ageGroupList;
  final List<Class> classList;
  final List<Club> clubs;
  final List<GeoRegion>? geoRegionIdList;
  final List<Region>? regionIdList;
  final int firstRow;
  final int maxCount;
  final int tournamentDatesSearch;
  final DateTime? startDate;
  final DateTime? endDate;
  final Profile? player;

  static const _undefinedPlayer = Object();

  SeasonPlanSearchFilter({
    required this.season,
    required this.ageGroupList,
    required this.classList,
    required this.clubs,
    required this.firstRow,
    required this.maxCount,
    required this.tournamentDatesSearch,
    this.geoRegionIdList,
    this.regionIdList,
    this.startDate,
    this.endDate,
    this.player,
  }) : assert(
         player == null || (ageGroupList.isEmpty && classList.isEmpty),
         'If playerId is set, ageGroupList and classIdList must be empty.',
       );

  factory SeasonPlanSearchFilter.fromJson(Map<String, dynamic> json) {
    return SeasonPlanSearchFilter(
      season: json['seasonId'] as Season,
      ageGroupList: json['ageGroupList'] as List<AgeGroup>,
      classList: json['classIdList'] as List<Class>,
      clubs: json['clubIds'] as List<Club>,
      geoRegionIdList: json['geoRegionIdList'] as List<GeoRegion>?,
      regionIdList: json['regionIdList'] as List<Region>?,
      firstRow: json['firstRow'] as int,
      maxCount: json['maxCount'] as int,
      tournamentDatesSearch: json['tournamentDatesSearch'] as int,
      startDate: json['dateFrom'] != null
          ? DateTime.parse(json['dateFrom'] as String)
          : null,
      endDate: json['dateTo'] != null
          ? DateTime.parse(json['dateTo'] as String)
          : null,
      player: json['playerId'],
    );
  }

  factory SeasonPlanSearchFilter.empty() {
    return SeasonPlanSearchFilter(
      season: Season(
        seasonId: 2025,
        name: "2025/2026",
        dateFrom: DateTime.now(),
        seasonPlan: true,
      ),
      ageGroupList: [],
      classList: [],
      clubs: [],
      firstRow: 0,
      maxCount: 20,
      tournamentDatesSearch: 0,
      geoRegionIdList: null,
      regionIdList: null,
      startDate: DateTime.now(),
      endDate: null,
      player: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasonId': season.seasonId,
      'ageGroupList': ageGroupList
          .map((ageGroup) => ageGroup.ageGroupId)
          .toList(),
      'classIdList': classList.map((classes) => classes.classID).toList(),
      'clubIds': clubs.map((club) => club.clubId).toList(),
      'geoRegionIdList': geoRegionIdList
          ?.map((geoRegion) => geoRegion.geoRegionID)
          .toList(),
      'regionIdList': regionIdList?.map((region) => region.regionId).toList(),
      'firstRow': firstRow,
      'maxCount': maxCount,
      'tournamentDatesSearch': tournamentDatesSearch,
      'dateFrom': startDate?.toIso8601String(),
      'dateTo': endDate?.toIso8601String(),
      'playerId': player?.id,
    };
  }

  SeasonPlanSearchFilter copyWith({
    Season? season,
    List<AgeGroup>? ageGroupList,
    List<Class>? classList,
    List<Club>? clubs,
    List<GeoRegion>? geoRegionIdList,
    List<Region>? regionIdList,
    int? firstRow,
    int? maxCount,
    int? tournamentDatesSearch,
    DateTime? startDate,
    DateTime? endDate,
    Object? player = _undefinedPlayer,
  }) {
    final Profile? newPlayer = identical(player, _undefinedPlayer)
        ? this.player
        : player as Profile?;
    return SeasonPlanSearchFilter(
      season: season ?? this.season,
      ageGroupList: ageGroupList ?? this.ageGroupList,
      classList: classList ?? this.classList,
      clubs: clubs ?? this.clubs,
      firstRow: firstRow ?? this.firstRow,
      maxCount: maxCount ?? this.maxCount,
      tournamentDatesSearch:
          tournamentDatesSearch ?? this.tournamentDatesSearch,
      geoRegionIdList: geoRegionIdList ?? this.geoRegionIdList,
      regionIdList: regionIdList ?? this.regionIdList,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      player: newPlayer,
    );
  }
}
