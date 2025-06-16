import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAutoFill extends ConsumerWidget {
  final StateProvider<Map<String, dynamic>> provider;
  final String providerKey;
  final String hint;
  final EdgeInsets? margin;
  final List<String> suggestions;
  final Map<String, dynamic> converter;
  final void Function(String)? onTap;
  final void Function(String)? onSubmitted;

  CustomAutoFill({
    super.key,
    required this.provider,
    required this.providerKey,
    required this.hint,
    required this.suggestions,
    this.margin,
    this.onTap,
    this.onSubmitted,
    this.converter = const {},
  });

  final TextEditingController textFieldController = TextEditingController();
  final GlobalKey<AutoCompleteTextFieldState<String>> textFieldKey =
      GlobalKey<AutoCompleteTextFieldState<String>>();

  final FocusNode textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    String initialValue = converter.entries
        .firstWhere(
            (entry) =>
                entry.value == ref.read(provider.notifier).state[providerKey],
            orElse: () => const MapEntry("", ""))
        .key;

    textFieldController.text =
        ref.read(provider.notifier).state[providerKey] == null
            ? ""
            : initialValue;

    return Container(
      margin: margin ?? const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffEBEBEB),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Row(
        children: [
          Expanded(
            child: AutoCompleteTextField<String>(
              focusNode: textFieldFocusNode,
              key: textFieldKey,
              controller: textFieldController,
              suggestions: suggestions,
              clearOnSubmit: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(4),
                isDense: true,
                isCollapsed: true,
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                ),
              ),
              style: TextStyle(
                color: colorThemeState.fontColor,
                fontSize: 14,
              ),
              itemFilter: (item, query) {
                return item.toLowerCase().contains(query.toLowerCase());
              },
              itemSorter: (a, b) {
                return b.compareTo(a);
              },
              unFocusOnItemSubmitted: true,
              itemSubmitted: onSubmitted ??
                  (item) {
                    ref.read(provider.notifier).state = {
                      ...ref.read(provider.notifier).state,
                      providerKey: converter[item],
                    };
                  },
              textSubmitted: (data) {
                if (data.isEmpty) {
                  ref.read(provider.notifier).state = {
                    ...ref.read(provider.notifier).state,
                    providerKey: "",
                  };
                }
              },
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item),
                );
              },
            ),
          ),
          if (onTap != null)
            Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.tune,
                    size: 18,
                    color: colorThemeState.primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
