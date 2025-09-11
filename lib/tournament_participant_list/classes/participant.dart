import 'package:html/dom.dart';

class Participant {
  List<ParticipantPlayer> players;
  int registratorId;
  String registratorName;
  String type;

  Participant({
    required this.players,
    required this.registratorId,
    required this.registratorName,
    required this.type,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      players: json['players'],
      registratorId: json['registratorId'],
      registratorName: json['registratorName'],
      type: json['type'],
    );
  }

  factory Participant.fromHtml(Element element, String type) {
    List<ParticipantPlayer> players = [];
    for (Element player
        in element.children[0].innerHtml
            .split("<br>")
            .map((e) => Element.html("<div>$e</div>"))) {
      players.add(ParticipantPlayer.fromHtml(player));
    }

    int registratorID =
        int.tryParse(
          element.children[1]
                  .querySelector("a")
                  ?.attributes['href']
                  ?.split("=")
                  .last ??
              "",
        ) ??
        -1;
    String registratorName =
        element.children[1].querySelector("a")?.text ?? "Ikke oplyst";

    return Participant(
      players: players,
      registratorId: registratorID,
      registratorName: registratorName,
      type: type,
    );
  }
}

class ParticipantPlayer {
  String participactionId;
  int playerId;
  String name;
  String club;
  int bwfId;

  ParticipantPlayer({
    required this.participactionId,
    required this.playerId,
    required this.name,
    required this.club,
    required this.bwfId,
  });

  factory ParticipantPlayer.fromJson(Map<String, dynamic> json) {
    return ParticipantPlayer(
      participactionId: json['participactionId'],
      playerId: json['playerId'],
      name: json['name'],
      club: json['club'],
      bwfId: json['bwfId'],
    );
  }

  factory ParticipantPlayer.fromHtml(Element element) {
    String participationId = element.text.split(" ")[0];
    int playerId =
        int.tryParse(
          element.querySelector("a")?.attributes['href']?.split("#").last ?? "",
        ) ??
        -1;

    String name = element.querySelector("a")?.text ?? "Ikke oplyst";

    List<String> clubAndBWF = element.text.split(", ").last.split("BWF ID::");
    String club = clubAndBWF[0].trim();
    int bwfId =
        int.tryParse((clubAndBWF.elementAtOrNull(1) ?? "").trim()) ?? -1;

    return ParticipantPlayer(
      participactionId: participationId,
      playerId: playerId,
      name: name,
      club: club,
      bwfId: bwfId,
    );
  }
}
