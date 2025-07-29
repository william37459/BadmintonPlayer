import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropDownSelector<T> extends ConsumerWidget {
  final String Function(T)? itemAsString;
  final List<T> Function(String, LoadProps?)? items;
  final Widget Function(BuildContext, T, bool, bool)? itemBuilder;
  final String hint;
  final T? initalValue;
  final List<T> selectedItems;
  final ValueChanged onChanged;
  final bool Function(T, T)? compareFn;
  final bool isMultiSelect;

  const CustomDropDownSelector({
    super.key,
    required this.itemAsString,
    required this.items,
    this.itemBuilder,
    required this.hint,
    this.initalValue,
    this.selectedItems = const [],
    this.compareFn,
    this.isMultiSelect = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return Container(
      decoration: BoxDecoration(
        color: colorThemeState.inputFieldColor,
        borderRadius: BorderRadius.circular(48),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(48),
        clipBehavior: Clip.antiAlias,
        child: isMultiSelect
            ? DropdownSearch<T>.multiSelection(
                items: items,
                itemAsString: itemAsString,
                onChanged: onChanged,
                dropdownBuilder: selectedItems.isNotEmpty
                    ? (context, selectedItems) {
                        return Text(
                          selectedItems
                              .map((element) => element.toString())
                              .join(", "),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorThemeState.fontColor,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                    : null,
                selectedItems: selectedItems,
                popupProps: PopupPropsMultiSelection.menu(
                  fit: FlexFit.loose,
                  showSearchBox: true,
                  showSelectedItems: true,
                  validationBuilder: (context, items) => InkWell(
                    onTap: () {
                      onChanged(items);
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        color: colorThemeState.primaryColor,
                        borderRadius: BorderRadius.circular(32),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32),
                          onTap: () {
                            onChanged(items);
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Text(
                              "Gem",
                              style: TextStyle(
                                color: colorThemeState.secondaryFontColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  checkBoxBuilder: (context, item, isDisabled, isSelected) =>
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? colorThemeState.primaryColor
                                : colorThemeState.fontColor.withValues(
                                    alpha: 0.3,
                                  ),
                            width: 2,
                          ),
                          color: isSelected
                              ? colorThemeState.primaryColor
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                size: 14,
                                color: colorThemeState.secondaryFontColor,
                              )
                            : null,
                      ),
                  searchDelay: Duration.zero,
                  itemBuilder:
                      itemBuilder ??
                      (context, item, isDisabled, isSelected) => ListTile(
                        title: Text(
                          itemAsString?.call(item) ?? item.toString(),
                          style: TextStyle(color: colorThemeState.fontColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        dense: true,
                        visualDensity: VisualDensity.compact,
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
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.5,
                          ),
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
                compareFn:
                    compareFn ??
                    (item1, item2) => item1.toString() == item2.toString(),
              )
            : DropdownSearch<T>(
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
                compareFn:
                    compareFn ??
                    (item1, item2) => item1.toString() == item2.toString(),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  showSelectedItems: true,
                  searchDelay: Duration.zero,
                  itemBuilder:
                      itemBuilder ??
                      (context, item, isDisabled, isSelected) => ListTile(
                        title: Text(
                          item.toString(),
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
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.5,
                          ),
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
