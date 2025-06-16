import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropDownSelector extends ConsumerWidget {
  final Map<String, String> data;
  final String hint;
  final String? initalValue;
  final ValueChanged onChanged;

  const CustomDropDownSelector(
      {super.key,
      required this.data,
      required this.hint,
      this.initalValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffEBEBEB),
        borderRadius: BorderRadius.circular(48),
      ),
      child: DropdownButton(
        onChanged: onChanged,
        hint: Text(
          hint,
        ),
        value: data.containsKey(initalValue) ? initalValue : null,
        isExpanded: true,
        isDense: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_sharp,
        ),
        style: TextStyle(
          color: colorThemeState.fontColor,
          fontSize: 14,
        ),
        underline: Container(),
        items: data.keys
            .map(
              (key) => DropdownMenuItem(
                value: key,
                child: Text(data[key] ?? ""),
              ),
            )
            .toList(),
      ),
    );
  }
}
