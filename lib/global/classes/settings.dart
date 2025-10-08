class Settings {
  final bool darkMode;
  final bool naturaltime;
  final bool starAtFavourites;
  final int elementsOnDashboard;
  final bool showFollowedTournaments;
  final bool showTournamentsForFollowedPlayers;
  final bool showComingTournaments;
  final List<int> showTournamentAgeGroups;

  Settings({
    required this.darkMode,
    required this.naturaltime,
    required this.starAtFavourites,
    required this.elementsOnDashboard,
    required this.showFollowedTournaments,
    required this.showTournamentsForFollowedPlayers,
    required this.showTournamentAgeGroups,
    required this.showComingTournaments,
  });

  factory Settings.empty() {
    return Settings(
      darkMode: false,
      naturaltime: false,
      starAtFavourites: false,
      elementsOnDashboard: 10,
      showFollowedTournaments: true,
      showTournamentsForFollowedPlayers: true,
      showComingTournaments: true,
      showTournamentAgeGroups: [],
    );
  }

  Settings copyWith({
    bool? darkMode,
    bool? naturaltime,
    bool? starAtFavourites,
    int? elementsOnDashboard,
    bool? showFollowedTournaments,
    bool? showTournamentsForFollowedPlayers,
    List<int>? showTournamentAgeGroups,
    bool? showComingTournaments,
  }) {
    return Settings(
      darkMode: darkMode ?? this.darkMode,
      naturaltime: naturaltime ?? this.naturaltime,
      starAtFavourites: starAtFavourites ?? this.starAtFavourites,
      elementsOnDashboard: elementsOnDashboard ?? this.elementsOnDashboard,
      showFollowedTournaments:
          showFollowedTournaments ?? this.showFollowedTournaments,
      showTournamentsForFollowedPlayers:
          showTournamentsForFollowedPlayers ??
          this.showTournamentsForFollowedPlayers,
      showTournamentAgeGroups:
          showTournamentAgeGroups ?? this.showTournamentAgeGroups,
      showComingTournaments:
          showComingTournaments ?? this.showComingTournaments,
    );
  }

  List<String> toStringList() {
    return [
      darkMode.toString(),
      naturaltime.toString(),
      starAtFavourites.toString(),
      elementsOnDashboard.toString(),
      showFollowedTournaments.toString(),
      showTournamentsForFollowedPlayers.toString(),
      showComingTournaments.toString(),
      showTournamentAgeGroups.join(
        ',',
      ), // Convert list to comma-separated string
    ];
  }

  factory Settings.fromStringList(List<String> stringList) {
    // Provide defaults in case the list is incomplete or has parsing errors
    return Settings(
      darkMode: stringList.isNotEmpty
          ? (stringList[0].toLowerCase() == 'true')
          : false,
      naturaltime: stringList.length > 1
          ? (stringList[1].toLowerCase() == 'true')
          : false,
      starAtFavourites: stringList.length > 2
          ? (stringList[2].toLowerCase() == 'true')
          : false,
      elementsOnDashboard: stringList.length > 3
          ? (int.tryParse(stringList[3]) ?? 10)
          : 10,
      showFollowedTournaments: stringList.length > 4
          ? (stringList[4].toLowerCase() == 'true')
          : true,
      showTournamentsForFollowedPlayers: stringList.length > 5
          ? (stringList[5].toLowerCase() == 'true')
          : true,
      showComingTournaments: stringList.length > 6
          ? (stringList[6].toLowerCase() == 'true')
          : true,
      showTournamentAgeGroups: stringList.length > 7 && stringList[7].isNotEmpty
          ? stringList[7]
                .split(',')
                .map((e) => int.tryParse(e.trim()) ?? 0)
                .where((e) => e != 0)
                .toList()
          : [],
    );
  }
}
