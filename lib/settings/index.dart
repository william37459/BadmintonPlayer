import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return Material(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: colorThemeState.backgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.chevron_left,
                        size: 32,
                        color: colorThemeState.fontColor.withValues(alpha: 0.5),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Indstillinger",
                        style: TextStyle(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.8,
                          ),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Udseende",
                  style: TextStyle(
                    color: colorThemeState.fontColor.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
              ),
              CustomContainer(
                child: Row(
                  children: [
                    Text(
                      "Mørk tilstand",
                      style: TextStyle(color: colorThemeState.fontColor),
                    ),
                    const Spacer(),
                    Switch(
                      value: colorThemeState.backgroundColor != Colors.white,
                      onChanged: (value) {
                        ref.read(colorThemeProvider.notifier).state = value
                            ? CustomColorTheme.dark()
                            : CustomColorTheme.light();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
