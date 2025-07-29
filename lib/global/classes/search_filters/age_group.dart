class AgeGroup {
  int ageGroupId;
  String ageGroupName;
  int yearsFrom;
  int yearsFromTournament;
  int? yearsTo;
  int? yearsToTournament;

  AgeGroup({
    required this.ageGroupId,
    required this.ageGroupName,
    required this.yearsFrom,
    required this.yearsFromTournament,
    this.yearsTo,
    this.yearsToTournament,
  });

  factory AgeGroup.fromJson(Map<String, dynamic> json) {
    return AgeGroup(
      ageGroupId: json['ageGroupId'],
      ageGroupName: json['ageGroupName'],
      yearsFrom: json['yearsFrom'],
      yearsFromTournament: json['yearsFromTournament'],
      yearsTo: json['yearsTo'],
      yearsToTournament: json['yearsToTournament'],
    );
  }

  @override
  String toString() {
    return ageGroupName;
  }
}
