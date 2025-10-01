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
}
