import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double standardBorderRadius = 12;

class CustomContainer extends ConsumerWidget {
  final Function()? onTap;
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  const CustomContainer({
    super.key,
    this.onTap,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.border,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return Padding(
      padding: margin ?? const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            borderRadius ?? standardBorderRadius,
          ),
          border:
              border ??
              Border.all(
                color: colorThemeState.shadowColor.withValues(alpha: 0.1),
                width: 1,
              ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            borderRadius ?? standardBorderRadius,
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: Material(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                color: backgroundColor ?? colorThemeState.backgroundColor,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: padding ?? const EdgeInsets.all(6.0),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
