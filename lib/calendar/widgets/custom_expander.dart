import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomExpander extends ConsumerWidget {
  final Widget header;
  final Widget body;
  final bool? isExpanded;
  final String isExpandedKey;
  final bool selfSpaced;

  const CustomExpander({
    super.key,
    required this.body,
    required this.header,
    required this.isExpandedKey,
    this.isExpanded,
    this.selfSpaced = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    Map<String, bool> isExpandedState = ref.watch(isExpandedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (isExpandedKey.isNotEmpty) {
              ref.read(isExpandedProvider.notifier).state = {
                ...isExpandedState,
                isExpandedKey: !(isExpandedState.containsKey(isExpandedKey)
                    ? isExpandedState[isExpandedKey] ?? false
                    : isExpanded ?? false)
              };
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              header,
              AnimatedRotation(
                turns: (isExpandedState.containsKey(isExpandedKey)
                        ? isExpandedState[isExpandedKey] ?? false
                        : isExpanded ?? false)
                    ? 0.5
                    : 0,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: colorThemeState.secondaryColor,
                ),
              ),
            ],
          ),
        ),
        if (!selfSpaced) const SizedBox(height: 8.0),
        AnimatedCrossFade(
          firstChild: body,
          secondChild: Container(),
          crossFadeState: (isExpandedState.containsKey(isExpandedKey)
                  ? isExpandedState[isExpandedKey] ?? false
                  : isExpanded ?? false)
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 250),
        )
      ],
    );
  }
}
