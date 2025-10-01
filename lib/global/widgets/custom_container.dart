import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomContainer extends ConsumerWidget {
  final Function()? onTap;
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final double? borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  const CustomContainer({
    super.key,
    this.onTap,
    this.margin,
    this.padding,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return Padding(
      padding: margin ?? const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
          border: border,
          boxShadow: [
            if (border == null)
              BoxShadow(
                color: colorThemeState.shadowColor,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: SizedBox(
          width: width,
          child: Material(
            borderRadius: BorderRadius.circular(4),
            color: backgroundColor ?? colorThemeState.backgroundColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: onTap,
              child: Padding(
                padding: padding ?? const EdgeInsets.all(6.0),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
