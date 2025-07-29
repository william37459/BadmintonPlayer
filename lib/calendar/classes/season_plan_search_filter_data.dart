import 'package:app/global/classes/club.dart';
import 'package:app/global/classes/search_filters/age_group.dart';
import 'package:app/global/classes/search_filters/class_group.dart';
import 'package:app/global/classes/search_filters/region.dart';
import 'package:app/global/classes/search_filters/seasons.dart';

class SeasonPlanSearchFilterData {
  final List<Season> seasons;
  final List<AgeGroup> ageGroups;
  final List<Class> classGroups;
  final List<Region> regions;
  final List<GeoRegion> geoRegions;
  final List<Club>? clubs;

  SeasonPlanSearchFilterData({
    this.seasons = const [],
    this.ageGroups = const [],
    this.classGroups = const [],
    this.regions = const [],
    this.geoRegions = const [],
    this.clubs,
  });

  factory SeasonPlanSearchFilterData.fromJson(Map<String, dynamic> json) {
    return SeasonPlanSearchFilterData(
      seasons: json['seasons'],
      ageGroups: json['ageGroups'],
      classGroups: json['class'],
      geoRegions: json['geoRegions'],
      regions: json['regions'],
    );
  }
}
