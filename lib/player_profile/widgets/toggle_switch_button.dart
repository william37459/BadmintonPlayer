import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/player_profile/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<int> choiceIndex = StateProvider<int>((ref) => 0);

class ToggleSwitchButton extends ConsumerWidget {
  final String label1;
  final String label2;
  final double marginTop;
  final bool enabled;
  const ToggleSwitchButton({
    super.key,
    required this.label1,
    required this.label2,
    required this.enabled,
    this.marginTop = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int choiceIndexState = ref.watch(choiceIndex);
    CustomColorTheme colorSchemeState = ref.watch(colorThemeProvider);

    return Padding(
      padding: EdgeInsets.only(top: marginTop),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: colorSchemeState.fontColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(128),
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChoiceWidget(
                    label: label1,
                    index: 0,
                  ),
                  ChoiceWidget(
                    label: label2,
                    index: 1,
                    enabled: enabled,
                  ),
                ],
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 150),
                alignment: choiceIndexState == 0
                    ? const Alignment(-1, 0)
                    : const Alignment(1, 0),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorSchemeState.primaryColor,
                      borderRadius: BorderRadius.circular(128),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        choiceIndexState == 0 ? label1 : label2,
                        style: TextStyle(
                          color: colorSchemeState.backgroundColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void changeIndex(WidgetRef ref, int newIndex, bool enabled) {
  tabController.animateTo(newIndex);
  if (enabled) {
    ref.read(choiceIndex.notifier).state = newIndex;
  }
}

class ChoiceWidget extends ConsumerWidget {
  final String label;
  final int index;
  final bool enabled;

  const ChoiceWidget({
    super.key,
    required this.label,
    required this.index,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorSchemeState = ref.watch(colorThemeProvider);

    return Expanded(
      child: InkWell(
        onTap: () => changeIndex(ref, index, enabled),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              enabled
                  ? Container()
                  : SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: colorSchemeState.primaryColor,
                      ),
                    ),
              enabled ? Container() : const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: colorSchemeState.fontColor.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
