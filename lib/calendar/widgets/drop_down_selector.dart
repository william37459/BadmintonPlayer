import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropDownSelector extends ConsumerWidget {
  final Map<String, String> data;
  final StateProvider<Map<String, dynamic>> provider;
  final String providerKey;
  final String hint;

  const CustomDropDownSelector({
    super.key,
    required this.data,
    required this.provider,
    required this.providerKey,
    required this.hint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var providerState = ref.watch(provider);

    return DropdownButton(
      onChanged: (value) {
        ref.read(provider.notifier).state = {
          ...providerState,
          providerKey: value,
        };
      },
      hint: Text(
        hint,
      ),
      value: data.containsKey(providerState[providerKey])
          ? providerState[providerKey]
          : null,
      isExpanded: true,
      isDense: true,
      icon: const Icon(Icons.keyboard_arrow_down_sharp),
      underline: Container(),
      items: data.keys
          .map(
            (key) => DropdownMenuItem(
              value: key,
              child: Text(data[key] ?? ""),
            ),
          )
          .toList(),
    );
  }
}
