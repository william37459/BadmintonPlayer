class Profile {
  String badmintonId;
  String id;
  String clubId;
  String name;
  String club;
  String gender;

  Profile({
    required this.id,
    required this.badmintonId,
    required this.name,
    required this.club,
    required this.gender,
    required this.clubId,
  });

  factory Profile.empty({
    String? id,
    String? badmintonId,
    String? name,
    String? club,
    String? gender,
    String? clubId,
  }) {
    return Profile(
      id: id ?? "",
      badmintonId: badmintonId ?? "",
      name: name ?? "",
      club: club ?? "",
      gender: gender ?? "",
      clubId: clubId ?? "",
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      badmintonId: json['badmintonId'],
      name: json['name'],
      club: json['club'],
      gender: json['gender'],
      clubId: json['clubId'],
    );
  }
}
