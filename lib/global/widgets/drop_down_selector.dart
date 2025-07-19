import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropDownSelector extends ConsumerWidget {
  final Map<String, String> data;
  final String hint;
  final String? initalValue;
  final ValueChanged onChanged;

  const CustomDropDownSelector({
    super.key,
    required this.data,
    required this.hint,
    this.initalValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Container(
      height: 41,
      padding: const EdgeInsets.only(left: 16, right: 4),
      decoration: BoxDecoration(
        color: const Color(0xffEBEBEB),
        borderRadius: BorderRadius.circular(48),
      ),
      child: DropdownSearch<String>(
        selectedItem: initalValue,
        items: data.keys.toList(),
        itemAsString: (item) => data[item] ?? item,
        onChanged: onChanged,
        dropdownButtonProps: const DropdownButtonProps(
            padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
        dropdownDecoratorProps: DropDownDecoratorProps(
          textAlignVertical: TextAlignVertical.center,
          dropdownSearchDecoration: InputDecoration(
            suffixIcon: const Icon(Icons.chevron_left),
            isCollapsed: true,
            isDense: true,
            alignLabelWithHint: false,
            contentPadding: EdgeInsets.zero,
            hint: Text(
              hint,
              style: TextStyle(
                fontSize: 14,
                color: colorThemeState.fontColor.withValues(alpha: 0.5),
              ),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchDelay: Duration.zero,
          emptyBuilder: (context, searchEntry) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Ingen resultater for '$searchEntry'",
              style: TextStyle(
                color: colorThemeState.fontColor.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              isDense: true,
              hintText: "Søg...",
              hintStyle: TextStyle(
                fontSize: 14,
                color: colorThemeState.fontColor.withValues(alpha: 0.5),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: colorThemeState.fontColor.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: colorThemeState.fontColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              dense: true,
              title: Text(
                data[item] ?? item,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? colorThemeState.primaryColor
                      : colorThemeState.fontColor,
                ),
              ),
            );
          },
          menuProps: MenuProps(
            backgroundColor: colorThemeState.backgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            clipBehavior: Clip.hardEdge,
          ),
        ),
      ),
    ); // Close SizedBox
  }
}
