import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropDownSelector extends ConsumerWidget {
  final String Function(dynamic)? itemAsString;
  final List<dynamic> Function(String, LoadProps?)? items;
  final Widget Function(BuildContext, dynamic, bool, bool)? itemBuilder;
  final String hint;
  final String? initalValue;
  final ValueChanged onChanged;
  final bool Function(dynamic, dynamic)? compareFn;

  const CustomDropDownSelector({
    super.key,
    required this.itemAsString,
    required this.items,
    this.itemBuilder,
    required this.hint,
    this.initalValue,
    this.compareFn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffEBEBEB),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(48),
        clipBehavior: Clip.antiAlias,
        child: DropdownSearch<dynamic>(
          items: items,
          selectedItem: initalValue,
          itemAsString: itemAsString,
          onChanged: onChanged,
          decoratorProps: DropDownDecoratorProps(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              constraints: const BoxConstraints(maxHeight: 41),
              isCollapsed: true,
              isDense: true,
              alignLabelWithHint: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: colorThemeState.fontColor.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          compareFn: compareFn,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchDelay: Duration.zero,
            itemBuilder:
                itemBuilder ??
                (context, item, isDisabled, isSelected) => ListTile(
                  title: Text(
                    item,
                    style: TextStyle(color: colorThemeState.fontColor),
                  ),
                ),
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
            menuProps: MenuProps(
              borderRadius: BorderRadius.circular(12),
              backgroundColor: colorThemeState.backgroundColor,
              clipBehavior: Clip.hardEdge,
            ),
          ),
        ),
      ),
    ); // Close SizedBox
  }
}
