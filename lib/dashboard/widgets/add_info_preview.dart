import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddInfoPreview extends ConsumerWidget {
  final VoidCallback onTap;
  final String text;
  final Color? color;
  final IconData? icon;
  const AddInfoPreview({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color ?? colorThemeState.primaryColor,
              size: 20,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color ?? colorThemeState.primaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
