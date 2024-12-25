import 'package:html/dom.dart';

class TournamentResultPreview {
  final DateTime date;
  final String rank;
  final String organiser;
  final String id;
  final String description;

  TournamentResultPreview({
    required this.date,
    required this.rank,
    required this.organiser,
    required this.id,
    this.description = "",
  });

  factory TournamentResultPreview.fromElement(Element element) {
    List<Element> allColumns = element.children;
    String id = allColumns[3]
            .children
            .first
            .attributes['href']
            ?.split("#")
            .last
            .replaceAll(",", "") ??
        "";
    return TournamentResultPreview(
      date: DateTime.parse(allColumns[0].text.split("-").reversed.join("-")),
      organiser: allColumns[1].text,
      description: allColumns[2].text,
      rank: allColumns[3].text,
      id: id,
    );
  }
}
