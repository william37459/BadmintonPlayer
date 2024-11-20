class Participant {
  final String registrator;
  final String category;
  final List<PlayerParticipant> players;

  Participant({
    required this.players,
    required this.registrator,
    required this.category,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      players: json['players'],
      registrator: json['registrator'],
      category: json['category'],
    );
  }
}

class PlayerParticipant {
  final String name;
  final String club;
  final String badmintonId;
  final String id;

  PlayerParticipant({
    required this.name,
    required this.club,
    required this.badmintonId,
    required this.id,
  });

  factory PlayerParticipant.fromJson(Map<String, dynamic> json) {
    return PlayerParticipant(
      name: json['name'],
      club: json['club'],
      badmintonId: json['badmintonId'],
      id: json['id'],
    );
  }
}
