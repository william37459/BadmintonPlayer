import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WrapperSelector extends ConsumerWidget {
  final Map data;
  final String providerKey;
  final StateProvider<Map<String, dynamic>> provider;
  final bool isMultiSelect;

  final StateProvider<List<String>> selectedData = StateProvider<List<String>>(
    (ref) => [],
  );

  WrapperSelector({
    super.key,
    required this.data,
    required this.provider,
    required this.providerKey,
    this.isMultiSelect = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    List<String> selectedDataState = ref.watch(selectedData);
    Map<String, dynamic> providerState = ref.watch(provider);

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (String value in data.keys.map((element) => element.toString()))
          Material(
            child: InkWell(
              onTap: () {
                Map<String, dynamic> filterMap = ref.read(provider);
                if (isMultiSelect) {
                  ref
                      .read(selectedData.notifier)
                      .state = selectedDataState.contains(value)
                      ? selectedDataState
                            .where((element) => element != value)
                            .toList()
                      : [...selectedDataState, value];
                  if (filterMap[providerKey] != null) {
                    if (!selectedDataState.contains("0") &&
                        filterMap[providerKey]?.contains("0")) {
                      filterMap[providerKey].remove("0");
                    } else {}
                  }
                  if (filterMap[providerKey] == null) {
                    filterMap[providerKey] = [value];
                  } else if (filterMap[providerKey]?.contains(value)) {
                    filterMap[providerKey].remove(value);
                    if (filterMap[providerKey].isEmpty &&
                        providerKey == "disciplines") {
                      filterMap[providerKey] = null;
                    }
                  } else {
                    filterMap[providerKey].add(value);
                  }

                  if (providerKey != "disciplines" &&
                      providerKey != "georegionids" &&
                      providerKey != "regionids" &&
                      filterMap[providerKey].isEmpty) {
                    filterMap[providerKey].add("0");
                  }
                  ref.read(provider.notifier).state = {...filterMap};
                } else {
                  if (ref.read(selectedData.notifier).state.contains(value)) {
                    ref.read(selectedData.notifier).state = [];
                    filterMap[providerKey] = "";
                  } else {
                    ref.read(selectedData.notifier).state = [value];
                    filterMap[providerKey] = value;
                  }
                  ref.read(provider.notifier).state = {...filterMap};
                }
              },
              borderRadius: BorderRadius.circular(4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  border: Border.all(color: colorThemeState.primaryColor),
                  color: colorThemeState.primaryColor.withValues(
                    alpha:
                        (providerState[providerKey]?.contains(value) ?? false)
                        ? 1
                        : 0.2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  data[value],
                  style: TextStyle(
                    color:
                        (providerState[providerKey]?.contains(value) ?? false)
                        ? colorThemeState.secondaryFontColor
                        : colorThemeState.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
