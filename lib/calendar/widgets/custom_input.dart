import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomInput extends ConsumerWidget {
  final StateProvider<Map<String, dynamic>> provider;
  final String providerKey;
  final String hint;
  final int? min;
  final int? max;
  final TextInputType? inputType;

  const CustomInput({
    super.key,
    required this.provider,
    required this.providerKey,
    required this.hint,
    this.min,
    this.max,
    this.inputType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController textFieldController = TextEditingController(
      text: ref.read(provider)[providerKey] ?? "",
    );

    textFieldController.selection = TextSelection.fromPosition(
      TextPosition(offset: textFieldController.text.length),
    );

    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return TextField(
      controller: textFieldController,
      keyboardType: inputType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(4),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorThemeState.primaryColor.withOpacity(0.3),
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
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          ref.read(provider.notifier).state = {
            ...ref.read(provider.notifier).state,
            providerKey: "",
          };
        } else if (inputType == TextInputType.number) {
          if (int.tryParse(value) == null) {
            textFieldController.text =
                textFieldController.text.replaceAll(RegExp(r"\D"), "");
          } else {
            if (max != null && int.parse(value) > max!) {
              textFieldController.text = "$max";
              ref.read(provider.notifier).state = {
                ...ref.read(provider.notifier).state,
                providerKey: "$max",
              };
            } else if (min != null && int.parse(value) < min!) {
              textFieldController.text = "$min";
              ref.read(provider.notifier).state = {
                ...ref.read(provider.notifier).state,
                providerKey: "$min",
              };
            } else {
              ref.read(provider.notifier).state = {
                ...ref.read(provider.notifier).state,
                providerKey: value,
              };
            }
          }
        } else {
          ref.read(provider.notifier).state = {
            ...ref.read(provider.notifier).state,
            providerKey: value,
          };
        }
      },
      onSubmitted: (data) {
        if (data.isEmpty) {
          ref.read(provider.notifier).state = {
            ...ref.read(provider.notifier).state,
            providerKey: data,
          };
        }
      },
    );
  }
}
