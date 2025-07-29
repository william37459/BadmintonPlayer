class Season {
  final int seasonId;
  final String name;
  final DateTime dateFrom;
  final bool seasonPlan;

  Season({
    required this.seasonId,
    required this.name,
    required this.dateFrom,
    required this.seasonPlan,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonId: json['seasonId'],
      name: json['name'],
      dateFrom: DateTime.parse(json['dateFrom']),
      seasonPlan: json['seasonPlan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasonId': seasonId,
      'name': name,
      'dateFrom': dateFrom.toIso8601String(),
      'seasonPlan': seasonPlan,
    };
  }

  @override
  String toString() {
    return name;
  }
}
