import 'package:app/global/classes/player_profile.dart';
import 'package:app/global/constants.dart';
import 'package:app/player_profile/functions/get_player_level.dart';
import 'package:app/player_profile/functions/get_player_profile.dart';
import 'package:app/calendar/widgets/drop_down_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

FutureProvider<PlayerProfile> playerProfileProvider =
    FutureProvider<PlayerProfile>((ref) async {
  final selectedPlayerId = ref.watch(selectedPlayer);
  final result = await getPlayerProfile(selectedPlayerId, contextKey);
  return result;
});

StateProvider<int?> signUpLevel = StateProvider<int?>((ref) {
  return null;
});

class PlayerProfilePage extends ConsumerWidget {
  final String name;
  final String id;
  const PlayerProfilePage({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorThemeState = ref.watch(colorThemeProvider);
    final signUpLevelState = ref.watch(signUpLevel);

    return PopScope(
      onPopInvoked: (isPop) {
        ref.read(signUpLevel.notifier).state = null;
      },
      child: Scaffold(
        floatingActionButton: Consumer(
          builder: (context, ref, child) {
            AsyncValue<PlayerProfile> futureAsyncValue =
                ref.watch(playerProfileProvider);
            return futureAsyncValue.when(
              error: (error, stackTrace) => Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  child: const Text(
                    "Der er sket en fejl, udvikleren er blevet underrettet og arbejder på at løse problemet!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              loading: () => Container(),
              data: (data) {
                if (data.scoreData.isNotEmpty &&
                    data.scoreData
                        .where(
                          (element) => element.type
                              .toLowerCase()
                              .contains("tilmeldingsniveau"),
                        )
                        .first
                        .points
                        .isEmpty) {
                  return FloatingActionButton.extended(
                    label: Text(
                      "Beregn tilmeldings niveau",
                      style: TextStyle(
                        color: colorThemeState.secondaryFontColor,
                      ),
                    ),
                    backgroundColor: colorThemeState.primaryColor,
                    onPressed: () async {
                      ref.read(signUpLevel.notifier).state =
                          await getPlayerLevel(id, name);
                    },
                  );
                }
                return Container();
              },
            );
          },
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  12,
                  8,
                  0,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorThemeState.secondaryColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: colorThemeState.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorThemeState.secondaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    AsyncValue<PlayerProfile> futureAsyncValue =
                        ref.watch(playerProfileProvider);
                    return futureAsyncValue.when(
                      error: (error, stackTrace) => Text(
                        error.toString(),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      data: (data) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Klub: ${data.club}",
                                style: TextStyle(
                                  color: colorThemeState.primaryColor
                                      .withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Sæson:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: colorThemeState.secondaryColor
                                          .withOpacity(0.75),
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomDropDownSelector(
                                      data: data.seasons,
                                      provider: selectedPlayer,
                                      providerKey: "season",
                                      hint: "Vælg sæson",
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (data.attachedProfiles.isNotEmpty)
                                        Text(
                                          "TILKNYTTEDE BURGERKOTNI",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                colorThemeState.secondaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      for (AttachedProfile profile
                                          in data.attachedProfiles)
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              onTap: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: colorThemeState
                                                              .secondaryColor,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        Icons.person_outline,
                                                        color: colorThemeState
                                                            .secondaryColor,
                                                        size: 18,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      profile.name,
                                                      style: TextStyle(
                                                        color: colorThemeState
                                                            .fontColor,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      if (data.scoreData.isNotEmpty)
                                        Text(
                                          "RANGLISTER",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                colorThemeState.secondaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      for (ScoreData score in data.scoreData)
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              onTap: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      score.placement.isEmpty &&
                                                              signUpLevelState !=
                                                                  null
                                                          ? signUpLevelState
                                                              .toString()
                                                          : score.placement,
                                                      style: TextStyle(
                                                        color: colorThemeState
                                                            .fontColor
                                                            .withOpacity(0.5),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    if (score.placement
                                                            .isNotEmpty ||
                                                        signUpLevelState !=
                                                            null)
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${score.type} ${score.rank}",
                                                          style: TextStyle(
                                                            color:
                                                                colorThemeState
                                                                    .fontColor,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        if (score
                                                            .points.isNotEmpty)
                                                          Text(
                                                            "${score.points} point, over ${score.matches} kampe",
                                                            style: TextStyle(
                                                              color:
                                                                  colorThemeState
                                                                      .fontColor,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      if (data.teamTournaments.isNotEmpty)
                                        Text(
                                          "HOLDKAMPE",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                colorThemeState.secondaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      for (TeamTournament teamTournament
                                          in data.teamTournaments)
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 2,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              onTap: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${teamTournament.team} - ${teamTournament.opponent}",
                                                    ),
                                                    Text(
                                                      teamTournament.rank,
                                                    ),
                                                    Text(
                                                      DateFormat("EEE d. MMMM",
                                                              'da_dk')
                                                          .format(teamTournament
                                                              .date),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      if (data.teamTournaments.isNotEmpty)
                                        Text(
                                          "TURNERNINGER",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                colorThemeState.secondaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      for (PlayerTournament tournament
                                          in data.tournaments)
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              onTap: () {
                                                ref
                                                    .read(selectedTournament
                                                        .notifier)
                                                    .state = tournament.id;
                                                Navigator.of(context).pushNamed(
                                                  "/TournamentResultPage",
                                                  arguments: {
                                                    "tournament":
                                                        tournament.club
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          tournament.club,
                                                          style: TextStyle(
                                                            color:
                                                                colorThemeState
                                                                    .fontColor,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          tournament.rank,
                                                          style: TextStyle(
                                                            color:
                                                                colorThemeState
                                                                    .fontColor,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                                  "EEE d. MMMM",
                                                                  'da_dk')
                                                              .format(tournament
                                                                  .date),
                                                          style: TextStyle(
                                                            color:
                                                                colorThemeState
                                                                    .fontColor,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Icon(
                                                      Icons.info_outline,
                                                      color: colorThemeState
                                                          .primaryColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 64,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
