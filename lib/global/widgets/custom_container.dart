import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final Color? backgroundColor;
  final bool shadow;
  final bool border;
  const CustomContainer({
    super.key,
    this.onTap,
    this.margin,
    this.padding,
    this.width,
    this.backgroundColor,
    this.border = false,
    this.shadow = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: border ? Colors.grey.withOpacity(0.2) : Colors.transparent,
          ),
          boxShadow: [
            if (shadow)
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
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
            color: backgroundColor ?? Colors.white,
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
