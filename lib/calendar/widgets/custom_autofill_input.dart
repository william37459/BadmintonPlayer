import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAutoFill extends ConsumerWidget {
  final StateProvider<Map<String, dynamic>> provider;
  final String providerKey;
  final String hint;
  final List<String> suggestions;
  final Map<String, dynamic> converter;

  CustomAutoFill({
    super.key,
    required this.provider,
    required this.providerKey,
    required this.hint,
    required this.suggestions,
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

    return AutoCompleteTextField<String>(
      focusNode: textFieldFocusNode,
      key: textFieldKey,
      controller: textFieldController,
      suggestions: suggestions,
      clearOnSubmit: false,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorThemeState.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorThemeState.primaryColor,
          ),
        ),
        isDense: true,
        isCollapsed: true,
        hintText: hint,
        hintStyle: const TextStyle(),
      ),
      itemFilter: (item, query) {
        return item.toLowerCase().contains(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return b.compareTo(a);
      },
      unFocusOnItemSubmitted: true,
      itemSubmitted: (item) {
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
    );
  }
}
