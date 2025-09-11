import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/tournament.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/tournament_participant_list/classes/participant.dart';
import 'package:app/tournament_participant_list/classes/tournament_class.dart';
import 'package:app/tournament_participant_list/functions/get_classes.dart';
import 'package:app/tournament_participant_list/functions/get_participaters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Map<String, String>> rankFilterProvider = StateProvider(
  (ref) => {},
);

StateProvider<int> selectedClass = StateProvider<int>((ref) => 0);

FutureProvider<List<Participant>> tournamentParticipationProvider =
    FutureProvider<List<Participant>>((ref) async {
      final int selectedClassState = ref.watch(selectedClass);

      return getParticipaters(selectedClassState);
    });

FutureProvider<List<TournamentClass>> tournamentClassProvider =
    FutureProvider<List<TournamentClass>>((ref) async {
      final int selectedTournamentState = ref.watch(selectedTournament);
      return await getClasses(selectedTournamentState);
    });

class TournamentParticipationList extends ConsumerStatefulWidget {
  final Tournament tournament;

  const TournamentParticipationList({super.key, required this.tournament});

  @override
  ConsumerState<TournamentParticipationList> createState() =>
      _TournamentParticipationListState();
}

class _TournamentParticipationListState
    extends ConsumerState<TournamentParticipationList>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void ensureControllerLength(int newLength) {
    if (newLength < 1) newLength = 1;
    if (tabController.length == newLength) return;

    final safeIndex = tabController.index.clamp(0, newLength - 1);
    tabController.dispose();
    tabController = TabController(
      length: newLength,
      vsync: this,
      initialIndex: safeIndex,
    );
    tabController.addListener(() {
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    AsyncValue<List<Participant>> participantListAsync = ref.watch(
      tournamentParticipationProvider,
    );

    AsyncValue<List<TournamentClass>> classListAsync = ref.watch(
      tournamentClassProvider,
    );

    final tabCount = classListAsync.maybeWhen(
      data: (classes) => (classes.length + 1),
      orElse: () => 1,
    );
    ensureControllerLength(tabCount);

    return Scaffold(
      backgroundColor: colorThemeState.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorThemeState.backgroundColor,
        title: Text(
          widget.tournament.title != null && widget.tournament.title!.isNotEmpty
              ? widget.tournament.title!
              : widget.tournament.clubName,
          style: TextStyle(color: colorThemeState.fontColor, fontSize: 16),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: colorThemeState.fontColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 48,
              child: classListAsync.when(
                data: (data) => ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < data.length; i++)
                      TabBarLabel(
                        label: "${data[i].ageGroupName} ${data[i].className}",
                        index: i,
                        currentIndex: tabController.index,
                        tabController: tabController,
                        onTap: () => ref.read(selectedClass.notifier).state =
                            data[i].tournamentClassID,

                        colorThemeState: colorThemeState,
                      ),
                  ],
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    "Kunne ikke hente klasser",
                    style: TextStyle(color: colorThemeState.fontColor),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
            participantListAsync.when(
              data: (data) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0 ||
                            data[index].type != data[index - 1].type) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              data[index].type,
                              style: TextStyle(
                                color: colorThemeState.fontColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        CustomContainer(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical:
                                (index == 0 ||
                                    data[index].type != data[index - 1].type)
                                ? 4
                                : 8,
                          ),
                          onTap: () => print("Tapped"),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index].players
                                          .map((e) => e.name)
                                          .join(", "),
                                      style: TextStyle(
                                        color: colorThemeState.fontColor,
                                      ),
                                    ),
                                    Text(
                                      data[index].players
                                          .map((e) => e.club)
                                          .join(", "),
                                      style: TextStyle(
                                        color: colorThemeState.fontColor
                                            .withAlpha(128),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.info_outline,
                                color: colorThemeState.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    itemCount: data.length,
                  ),
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () => const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarLabel extends StatelessWidget {
  final String label;
  final int index;
  final int currentIndex;
  final TabController tabController;
  final CustomColorTheme colorThemeState;
  final Function()? onTap;

  const TabBarLabel({
    super.key,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.tabController,
    required this.colorThemeState,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = currentIndex == index;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: 1,
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              tabController.animateTo(index);
              onTap?.call();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: isSelected
                    ? Border(
                        bottom: BorderSide(
                          color: colorThemeState.primaryColor,
                          width: 1,
                        ),
                      )
                    : null,
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? colorThemeState.primaryColor
                      : colorThemeState.fontColor,
                  fontWeight: isSelected ? FontWeight.w600 : null,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
