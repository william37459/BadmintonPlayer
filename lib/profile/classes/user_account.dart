import 'package:html/dom.dart';

class UserAccount {
  final String email;
  final String name;
  final List<String> phoneNumbers;
  final String street;
  final String postalCode;
  final String city;
  final bool publicProfile;
  final bool newsletter;
  final bool tournamentInfo;
  final bool rankingInfo;
  final bool teamtournamentInfo;

  UserAccount({
    required this.email,
    required this.name,
    required this.phoneNumbers,
    required this.street,
    required this.postalCode,
    required this.city,
    required this.publicProfile,
    required this.newsletter,
    required this.tournamentInfo,
    required this.rankingInfo,
    required this.teamtournamentInfo,
  });

  UserAccount copyWith({
    String? email,
    String? name,
    List<String>? phoneNumbers,
    String? street,
    String? postalCode,
    String? city,
    bool? publicProfile,
    bool? newsletter,
    bool? tournamentInfo,
    bool? rankingInfo,
    bool? teamtournamentInfo,
  }) {
    return UserAccount(
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      publicProfile: publicProfile ?? this.publicProfile,
      newsletter: newsletter ?? this.newsletter,
      tournamentInfo: tournamentInfo ?? this.tournamentInfo,
      rankingInfo: rankingInfo ?? this.rankingInfo,
      teamtournamentInfo: teamtournamentInfo ?? this.teamtournamentInfo,
    );
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      phoneNumbers: List<String>.from(json['phoneNumbers'] ?? []),
      street: json['street'] ?? "",
      postalCode: json['postalCode'] ?? "",
      city: json['city'] ?? "",
      publicProfile: json['publicProfile'] ?? false,
      newsletter: json['newsletter'] ?? false,
      tournamentInfo: json['tournamentInfo'] ?? false,
      rankingInfo: json['rankingInfo'] ?? false,
      teamtournamentInfo: json['teamtournamentInfo'] ?? false,
    );
  }

  factory UserAccount.fromElement(Element? element) {
    String email =
        element
            ?.querySelector("#ctl00_ContentPlaceHolder1_LabelEmail")
            ?.text
            .trim() ??
        "";

    String name =
        element
            ?.querySelector("#ctl00_ContentPlaceHolder1_TextBoxName")
            ?.attributes['value']
            ?.trim() ??
        "";

    List<String> phoneNumbers =
        element
            ?.querySelector("#ctl00_ContentPlaceHolder1_TextBoxPhone")
            ?.attributes['value']
            ?.trim()
            .split("_")
            .map((e) => "+45${e.trim()}")
            .toList() ??
        [];
    String street =
        element
            ?.querySelector("#ctl00_ContentPlaceHolder1_TextBoxStreet")
            ?.attributes['value']
            ?.trim() ??
        "";
    String postalCode =
        element
            ?.querySelector("#ctl00_ContentPlaceHolder1_TextBoxPostalCode")
            ?.attributes['value']
            ?.trim() ??
        "";
    String city =
        element
            ?.querySelector("#ctl00_ContentPlaceHolder1_TextBoxCity")
            ?.attributes['value']
            ?.trim() ??
        "";

    bool publicProfile =
        (element
                ?.querySelector("#ctl00_ContentPlaceHolder1_CheckBoxPublic")
                ?.attributes['checked'] ??
            "") ==
        "checked";

    bool newsletter =
        (element
                ?.querySelector(
                  "#ctl00_ContentPlaceHolder1_CheckBoxListMailTypesLock_0",
                )
                ?.attributes['checked'] ??
            "") ==
        "checked";

    bool tournamentInfo =
        (element
                ?.querySelector(
                  "#ctl00_ContentPlaceHolder1_CheckBoxListMailTypes_0",
                )
                ?.attributes['checked'] ??
            "") ==
        "checked";

    bool rankingInfo =
        (element
                ?.querySelector(
                  "#ctl00_ContentPlaceHolder1_CheckBoxListMailTypes_1",
                )
                ?.attributes['checked'] ??
            "") ==
        "checked";

    bool teamtournamentInfo =
        (element
                ?.querySelector(
                  "#ctl00_ContentPlaceHolder1_CheckBoxListMailTypes_2",
                )
                ?.attributes['checked'] ??
            "") ==
        "checked";

    return UserAccount(
      email: email,
      name: name,
      phoneNumbers: phoneNumbers,
      street: street,
      postalCode: postalCode,
      city: city,
      publicProfile: publicProfile,
      newsletter: newsletter,
      tournamentInfo: tournamentInfo,
      rankingInfo: rankingInfo,
      teamtournamentInfo: teamtournamentInfo,
    );
  }

  Map<String, String> toJson() {
    String base = "ctl00\$ContentPlaceHolder1\$";
    String baseText = "${base}TextBox";
    String baseCheck = "${base}CheckBox";
    Map<String, String> result = {
      '${baseText}Email': email,
      '${baseText}Name': name,
      '${baseText}Phone': phoneNumbers.join("_").replaceAll("+45", ""),
      '${baseText}Street': street,
      '${baseText}PostalCode': postalCode,
      '${baseText}City': city,
      '${baseCheck}CheckBoxPublic': publicProfile ? "on" : "",
      '${baseCheck}ListMailTypes\$0': newsletter ? "on" : "",
      '${baseCheck}ListMailTypes\$1': rankingInfo ? "on" : "",
      '${baseCheck}ListMailTypes\$3': teamtournamentInfo ? "on" : "",
    };

    result.removeWhere((key, value) => value.isEmpty);
    return result;
  }
}
