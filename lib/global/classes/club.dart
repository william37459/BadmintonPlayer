class Club {
  final int clubId;
  final String clubName;
  final String fullClubName;

  Club({
    required this.clubId,
    required this.clubName,
    required this.fullClubName,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      clubId: json["clubId"],
      clubName: json["clubName"],
      fullClubName: json["fullClubName"],
    );
  }
}
