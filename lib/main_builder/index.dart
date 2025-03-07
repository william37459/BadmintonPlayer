import 'package:app/dashboard/index.dart';
import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/profile/index.dart';
import 'package:app/score_list/index.dart';
import 'package:app/team_tournament/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<int> index = StateProvider<int>((ref) => 0);

List<Widget> pages = [
  Dashboard(),
  const ScoreList(),
  const TeamTournamentPage(),
  const ProfilePage(),
];

class MainBuilder extends ConsumerWidget {
  const MainBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int indexState = ref.watch(index);
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Scaffold(
      backgroundColor: colorThemeState.backgroundColor,
      body: pages[indexState],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexState,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorThemeState.primaryColor,
        unselectedItemColor: colorThemeState.fontColor.withValues(alpha: 0.5),
        backgroundColor: colorThemeState.backgroundColor,
        onTap: (value) => ref.read(index.notifier).state = value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Hjem',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered_outlined),
            label: 'Rangliste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Holdkamp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
