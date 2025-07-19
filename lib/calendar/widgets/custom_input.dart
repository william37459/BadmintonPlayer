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
  final bool obscureText;
  final TextEditingController? controller;

  const CustomInput({
    super.key,
    required this.provider,
    required this.providerKey,
    required this.hint,
    this.min,
    this.max,
    this.inputType,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    if (controller != null) {
      controller!.text = ref.read(provider)[providerKey] ?? "";
    }
    final TextEditingController textFieldController = TextEditingController(
      text: ref.read(provider)[providerKey] ?? "",
    );

    textFieldController.selection = TextSelection.fromPosition(
      TextPosition(offset: textFieldController.text.length),
    );

    return TextField(
      controller: controller ?? textFieldController,
      keyboardType: inputType,
      obscureText: obscureText,
      decoration: InputDecoration.collapsed(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14),
      ),
      cursorColor: colorThemeState.primaryColor,
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
