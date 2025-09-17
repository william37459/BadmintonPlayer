// ignore_for_file: non_constant_identifier_names

class Tournament {
  final int tournamentID;
  final int tournamentClassID;
  final String tournamentNumber;
  final int seasonID;
  final DateTime dateTo;
  final DateTime? lastRegistration;
  final int? roundID;
  final int? regionID;
  final int tournamentState;
  final int tournamentType;
  final String? title;
  final String clubName;
  final int? clubID;
  final String clubNumber;
  final int recurring;
  final int? clubUserID;
  final String contactName;
  final String contactEmail;
  final bool weekChanged;
  final DateTime dateFrom;
  final String contactAddress;
  final String contactCity;
  final String contactPostalCode;
  final String contactCountryCode;
  final String contactPhoneMobile;
  final String contactPhoneWork;
  final String contactPhone;
  final String? comment;
  final int? geoRegionID;
  final String? urlInvitation;
  final String? urlProgram;
  final String? invitationPDF;
  final String? programPDF;
  final int? tI_Activ;
  final int? tI_Program;
  final String? tI_Ekstern_Inv_Link;
  final String? tI_Ekstern_Pro_Link;
  final bool? liveScore;
  final String? liveScoreCode;
  final List<TournamentLink> tournamentLink;
  final List<TournamentDetails> details;

  Tournament({
    required this.tournamentID,
    required this.tournamentClassID,
    required this.tournamentNumber,
    required this.seasonID,
    required this.dateTo,
    this.lastRegistration,
    this.roundID,
    this.regionID,
    required this.tournamentState,
    required this.tournamentType,
    this.title,
    required this.clubName,
    this.clubID,
    required this.clubNumber,
    required this.recurring,
    this.clubUserID,
    required this.contactName,
    required this.contactEmail,
    required this.weekChanged,
    required this.dateFrom,
    required this.contactAddress,
    required this.contactCity,
    required this.contactPostalCode,
    required this.contactCountryCode,
    required this.contactPhoneMobile,
    required this.contactPhoneWork,
    required this.contactPhone,
    this.comment,
    this.geoRegionID,
    this.urlInvitation,
    this.urlProgram,
    this.invitationPDF,
    this.programPDF,
    this.tI_Activ,
    this.tI_Program,
    this.tI_Ekstern_Inv_Link,
    this.tI_Ekstern_Pro_Link,
    this.liveScore,
    this.liveScoreCode,
    required this.tournamentLink,
    required this.details,
  });

  factory Tournament.fromJson(
    Map<String, dynamic> json,
    List<TournamentDetails> tournamentDetails,
  ) {
    List<TournamentLink> tournamentLinks = [];
    for (int i = 0; i < (json['tournamentLink']?.length ?? 0); i++) {
      tournamentLinks.add(TournamentLink.fromJson(json['tournamentLink'][i]));
    }

    return Tournament(
      tournamentID: json['tournamentID'],
      tournamentClassID: json['tournamentClassID'],
      tournamentNumber: json['tournamentNumber'] ?? '',
      seasonID: json['seasonID'],
      dateTo: DateTime.parse(json['dateTo']),
      lastRegistration: json['lastRegistration'] != null
          ? DateTime.parse(json['lastRegistration'])
          : null,
      roundID: json['roundID'],
      regionID: json['regionID'],
      tournamentState: json['tournamentState'],
      tournamentType: json['tournamentType'],
      title: json['title'],
      clubName: json['clubName'] ?? '',
      clubID: json['clubID'],
      clubNumber: json['clubNumber'] ?? '',
      recurring: json['recurring'],
      clubUserID: json['clubUserID'],
      contactName: json['contactName'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      weekChanged: json['weekChanged'],
      dateFrom: DateTime.parse(json['dateFrom']),
      contactAddress: json['contactAddress'] ?? '',
      contactCity: json['contactCity'] ?? '',
      contactPostalCode: json['contactPostalCode'] ?? '',
      contactCountryCode: json['contactCountryCode'] ?? '',
      contactPhoneMobile: json['contactPhoneMobile'] ?? '',
      contactPhoneWork: json['contactPhoneWork'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      comment: json['comment'],
      geoRegionID: json['geoRegionID'],
      urlInvitation: json['urlInvitation'],
      urlProgram: json['urlProgram'],
      invitationPDF: json['invitationPDF'],
      programPDF: json['programPDF'],
      tI_Activ: json['tI_Activ'],
      tI_Program: json['tI_Program'],
      tI_Ekstern_Inv_Link: json['tI_Ekstern_Inv_Link'],
      tI_Ekstern_Pro_Link: json['tI_Ekstern_Pro_Link'],
      liveScore: json['liveScore'],
      liveScoreCode: json['liveScoreCode'],
      tournamentLink: tournamentLinks,
      details: tournamentDetails,
    );
  }

  bool participatersReady() {
    if (tournamentType == 104) {
      return false;
    }
    for (var link in tournamentLink) {
      if (link.tournamentLinkType == 0) {
        return true;
      }
    }
    return false;
  }

  bool resultsReady() {
    if (tournamentType == 104) {
      return false;
    }
    for (var link in tournamentLink) {
      if (link.tournamentLinkType == 4) {
        return true;
      }
    }
    return false;
  }

  List<String> getClassAndAgeGroupCodes() {
    List<String> classAndAgeGroupCodes = [];
    for (var detail in details) {
      classAndAgeGroupCodes.add("${detail.ageGroupCode} ${detail.classCode}");
    }
    return classAndAgeGroupCodes;
  }

  List<String> getFormattedClassAndAgeGroupCodes() {
    Map<String, List<String>> classAndAgeGroupCodes = {};
    for (var detail in details) {
      classAndAgeGroupCodes
          .putIfAbsent(detail.ageGroupCode, () => [])
          .add(detail.classCode);
    }

    List<String> formattedClassAndAgeGroupCodes = [];

    classAndAgeGroupCodes.forEach((key, value) {
      formattedClassAndAgeGroupCodes.add("$key ${value.join(', ')}");
    });

    return formattedClassAndAgeGroupCodes;
  }

  @override
  String toString() {
    String startDate = dateFrom.toIso8601String();
    String endDate = dateTo.toIso8601String();
    String id = tournamentID.toString();

    return "${startDate}_${endDate}_$id";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tournament &&
          runtimeType == other.runtimeType &&
          tournamentID == other.tournamentID;

  @override
  int get hashCode => tournamentID.hashCode;
}

class TournamentLink {
  final bool isAllow;
  final String? link;
  final int tournamentLinkType;

  TournamentLink({
    required this.isAllow,
    required this.link,
    required this.tournamentLinkType,
  });

  factory TournamentLink.fromJson(Map<String, dynamic> json) {
    return TournamentLink(
      isAllow: json['isAllow'],
      link: json['link'],
      tournamentLinkType: json['tournamentLinkType'],
    );
  }
}

class TournamentDetails {
  String ageGroupCode;
  int ageGroupID;
  String? ageGroupName;
  DateTime? bornFrom;
  DateTime? bornTo;
  String classCode;
  DateTime classDateFrom;
  DateTime classDateTo;
  int classID;
  String? className;
  int? maxEvents;
  bool noValidateAgeGroup;
  bool noValidateClass;
  int? rankingPointsFromFemale;
  int? rankingPointsFromMale;
  int? rankingPointsToFemale;
  int? rankingPointsToMale;
  int tournamentClassID;
  String? tournamentClassInfo;
  String? tournamentClassTitle;
  int tournamentID;
  String? tournamentNumber;
  int tournamentState;
  int? validationRule;

  TournamentDetails({
    required this.ageGroupCode,
    required this.ageGroupID,
    this.ageGroupName,
    this.bornFrom,
    this.bornTo,
    required this.classCode,
    required this.classDateFrom,
    required this.classDateTo,
    required this.classID,
    this.className,
    this.maxEvents,
    required this.noValidateAgeGroup,
    required this.noValidateClass,
    this.rankingPointsFromFemale,
    this.rankingPointsFromMale,
    this.rankingPointsToFemale,
    this.rankingPointsToMale,
    required this.tournamentClassID,
    this.tournamentClassInfo,
    this.tournamentClassTitle,
    required this.tournamentID,
    this.tournamentNumber,
    required this.tournamentState,
    this.validationRule,
  });

  factory TournamentDetails.fromJson(Map<String, dynamic> json) {
    return TournamentDetails(
      ageGroupCode: json['ageGroupCode'],
      ageGroupID: json['ageGroupID'],
      ageGroupName: json['ageGroupName'],
      bornFrom: json['bornFrom'] != null
          ? DateTime.parse(json['bornFrom'])
          : null,
      bornTo: json['bornTo'] != null ? DateTime.parse(json['bornTo']) : null,
      classCode: json['classCode'],
      classDateFrom: DateTime.parse(json['classDateFrom']),
      classDateTo: DateTime.parse(json['classDateTo']),
      classID: json['classID'],
      className: json['className'],
      maxEvents: json['maxEvents'],
      noValidateAgeGroup: json['noValidateAgeGroup'],
      noValidateClass: json['noValidateClass'],
      rankingPointsFromFemale: json['rankingPointsFromFemale'],
      rankingPointsFromMale: json['rankingPointsFromMale'],
      rankingPointsToFemale: json['rankingPointsToFemale'],
      rankingPointsToMale: json['rankingPointsToMale'],
      tournamentClassID: json['tournamentClassID'],
      tournamentClassInfo: json['tournamentClassInfo'],
      tournamentClassTitle: json['tournamentClassTitle'],
      tournamentID: json['tournamentID'],
      tournamentNumber: json['tournamentNumber'],
      tournamentState: json['tournamentState'],
      validationRule: json['validationRule'],
    );
  }
}
