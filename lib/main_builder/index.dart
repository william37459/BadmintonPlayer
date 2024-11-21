import 'package:app/dashboard/index.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/player_profile_search/index.dart';
import 'package:app/score_list/index.dart';
import 'package:app/team_tournament/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<int> index = StateProvider<int>((ref) => 0);

List<Widget> pages = [
  Dashboard(),
  PlayerSearch(),
  const ScoreList(),
  const TeamTournamentPage(),
  // const ProfilePage(),
];

class MainBuilder extends ConsumerWidget {
  const MainBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int indexState = ref.watch(index);
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Scaffold(
      body: pages[indexState],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexState,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorThemeState.primaryColor,
        unselectedItemColor: colorThemeState.primaryColor.withOpacity(0.5),
        onTap: (value) => ref.read(index.notifier).state = value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Søgning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered_outlined),
            label: 'Rangliste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Holdkamp',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profil',
          // ),
        ],
      ),
    );
  }
}
