class Season {
  DateTime dateFrom;
  String name;
  int seasonId;
  bool seasonPlan;

  Season({
    required this.dateFrom,
    required this.name,
    required this.seasonId,
    required this.seasonPlan,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      dateFrom: DateTime.parse(json['dateFrom']),
      name: json['name'],
      seasonId: json['seasonId'],
      seasonPlan: json['seasonPlan'],
    );
  }
}
