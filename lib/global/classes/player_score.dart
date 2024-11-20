class PlayerScore {
  String id;
  String badmintonId;
  String name;
  String? club;
  String rank;
  String rankClass;
  String? points;

  PlayerScore({
    required this.id,
    required this.badmintonId,
    required this.name,
    required this.club,
    required this.rank,
    required this.rankClass,
    this.points,
  });

  factory PlayerScore.fromJson(Map<String, dynamic> json) {
    return PlayerScore(
      badmintonId: json['id'],
      id: json['id'],
      name: json['name'],
      club: json['club'],
      rank: json['rank'],
      rankClass: json['rankClass'],
      points: json['points'],
    );
  }
}
