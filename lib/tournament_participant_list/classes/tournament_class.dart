class TournamentClass {
  final int tournamentClassID;
  final int tournamentID;
  final int ageGroupID;
  final int classID;
  final String? tournamentNumber;
  final String? ageGroupCode;
  final String ageGroupName;
  final String? classCode;
  final String className;
  final int tournamentState;
  final int? maxEvents;
  final bool noValidateAgeGroup;
  final bool noValidateClass;
  final String? tournamentClassTitle;
  final String? bornFrom;
  final String? bornTo;
  final String? tournamentClassInfo;
  final DateTime? classDateFrom;
  final DateTime? classDateTo;
  final int? rankingPointsFromMale;
  final int? rankingPointsToMale;
  final int? rankingPointsFromFemale;
  final int? rankingPointsToFemale;
  final int? validationRule;

  const TournamentClass({
    required this.tournamentClassID,
    required this.tournamentID,
    required this.ageGroupID,
    required this.classID,
    this.tournamentNumber,
    this.ageGroupCode,
    required this.ageGroupName,
    this.classCode,
    required this.className,
    required this.tournamentState,
    this.maxEvents,
    required this.noValidateAgeGroup,
    required this.noValidateClass,
    this.tournamentClassTitle,
    this.bornFrom,
    this.bornTo,
    this.tournamentClassInfo,
    this.classDateFrom,
    this.classDateTo,
    this.rankingPointsFromMale,
    this.rankingPointsToMale,
    this.rankingPointsFromFemale,
    this.rankingPointsToFemale,
    this.validationRule,
  });

  factory TournamentClass.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is String && v.isNotEmpty) return DateTime.parse(v);
      return null;
    }

    return TournamentClass(
      tournamentClassID: json['tournamentClassID'] as int,
      tournamentID: json['tournamentID'] as int,
      ageGroupID: json['ageGroupID'] as int,
      classID: json['classID'] as int,
      tournamentNumber: json['tournamentNumber'] as String?,
      ageGroupCode: json['ageGroupCode'] as String?,
      ageGroupName: json['ageGroupName'] as String,
      classCode: json['classCode'] as String?,
      className: json['className'] as String,
      tournamentState: json['tournamentState'] as int,
      maxEvents: json['maxEvents'] as int?,
      noValidateAgeGroup: json['noValidateAgeGroup'] as bool,
      noValidateClass: json['noValidateClass'] as bool,
      tournamentClassTitle: json['tournamentClassTitle'] as String?,
      bornFrom: json['bornFrom'] as String?,
      bornTo: json['bornTo'] as String?,
      tournamentClassInfo: json['tournamentClassInfo'] as String?,
      classDateFrom: parseDate(json['classDateFrom']),
      classDateTo: parseDate(json['classDateTo']),
      rankingPointsFromMale: json['rankingPointsFromMale'] as int?,
      rankingPointsToMale: json['rankingPointsToMale'] as int?,
      rankingPointsFromFemale: json['rankingPointsFromFemale'] as int?,
      rankingPointsToFemale: json['rankingPointsToFemale'] as int?,
      validationRule: json['validationRule'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tournamentClassID': tournamentClassID,
      'tournamentID': tournamentID,
      'ageGroupID': ageGroupID,
      'classID': classID,
      'tournamentNumber': tournamentNumber,
      'ageGroupCode': ageGroupCode,
      'ageGroupName': ageGroupName,
      'classCode': classCode,
      'className': className,
      'tournamentState': tournamentState,
      'maxEvents': maxEvents,
      'noValidateAgeGroup': noValidateAgeGroup,
      'noValidateClass': noValidateClass,
      'tournamentClassTitle': tournamentClassTitle,
      'bornFrom': bornFrom,
      'bornTo': bornTo,
      'tournamentClassInfo': tournamentClassInfo,
      'classDateFrom': classDateFrom?.toIso8601String(),
      'classDateTo': classDateTo?.toIso8601String(),
      'rankingPointsFromMale': rankingPointsFromMale,
      'rankingPointsToMale': rankingPointsToMale,
      'rankingPointsFromFemale': rankingPointsFromFemale,
      'rankingPointsToFemale': rankingPointsToFemale,
      'validationRule': validationRule,
    };
  }
}
