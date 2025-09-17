import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditableProfileText extends ConsumerWidget {
  final String header;
  final List<String> value;
  final void Function(dynamic)? onChanged;

  const EditableProfileText({
    super.key,
    required this.value,
    required this.header,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorthemeState = ref.watch(colorThemeProvider);
    if (bool.tryParse(value.first) != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Checkbox(
              visualDensity: VisualDensity.compact,
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colorthemeState.primaryColor;
                }
                return colorthemeState.backgroundColor;
              }),
              value: bool.parse(value.first),
              onChanged: onChanged,
            ),
            Text(
              header,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: colorthemeState.fontColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            header,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: colorthemeState.fontColor.withValues(alpha: 0.7),
            ),
          ),
        ),
        ...value.map(
          (e) => CustomContainer(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            border: BoxBorder.all(
              color: colorthemeState.fontColor.withValues(alpha: 0.1),
            ),
            padding: EdgeInsets.zero,
            child: TextField(
              controller: TextEditingController(text: e)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: e.length),
                ),
              style: TextStyle(fontSize: 14, color: colorthemeState.fontColor),
              decoration: const InputDecoration(
                isDense: true,
                isCollapsed: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
