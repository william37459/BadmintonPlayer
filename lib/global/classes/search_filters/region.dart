class Region {
  String name;
  int? parentId;
  int regionId;
  String? shortName;

  Region({
    required this.name,
    this.parentId,
    required this.regionId,
    required this.shortName,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      name: json['name'],
      parentId: json['parentId'],
      regionId: json['regionId'],
      shortName: json['shortName'],
    );
  }

  @override
  String toString() {
    return shortName ?? name;
  }
}

class GeoRegion {
  int geoRegionID;
  String name;
  int unionID;

  GeoRegion({
    required this.geoRegionID,
    required this.name,
    required this.unionID,
  });

  factory GeoRegion.fromJson(Map<String, dynamic> json) {
    return GeoRegion(
      geoRegionID: json['geoRegionID'],
      name: json['name'],
      unionID: json['unionID'],
    );
  }
  @override
  String toString() {
    return name;
  }
}
