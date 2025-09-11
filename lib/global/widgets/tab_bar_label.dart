import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabBarLabel extends ConsumerWidget {
  final String label;
  final int index;
  final int currentIndex;
  final TabController tabController;
  final Function()? onTap;

  const TabBarLabel({
    super.key,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.tabController,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            tabController.animateTo(index);
            if (onTap != null) {
              onTap!();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: currentIndex == index
                      ? colorThemeState.primaryColor
                      : colorThemeState.fontColor.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: currentIndex == index
                    ? colorThemeState.primaryColor
                    : colorThemeState.fontColor.withValues(alpha: 0.8),
                fontWeight: currentIndex == index
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
