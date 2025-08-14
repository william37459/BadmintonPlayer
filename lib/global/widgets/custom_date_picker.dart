import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends ConsumerWidget {
  final StateProvider<Map<String, dynamic>> provider;
  final String providerKey;
  final String hintText;

  const CustomDatePicker({
    super.key,
    required this.provider,
    required this.providerKey,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> filterState = ref.watch(provider);
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);

    return Material(
      child: InkWell(
        onTap: () {
          DateTime today = DateTime.now();
          if (ref.read(provider)[providerKey] == null ||
              ref.read(provider)[providerKey].isEmpty) {
            ref.read(provider.notifier).state = {
              ...ref.read(provider),
              providerKey: "${today.day}-${today.month}-${today.year}",
            };
          }
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CustomPickerWidget(
              provider: provider,
              providerKey: providerKey,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  filterState[providerKey] == null ||
                          filterState[providerKey].isEmpty
                      ? hintText
                      : filterState[providerKey],
                  style: TextStyle(
                    color:
                        filterState[providerKey] == null ||
                            filterState[providerKey].isEmpty
                        ? colorThemeState.fontColor.withValues(alpha: 0.5)
                        : colorThemeState.fontColor,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity:
                    filterState[providerKey] == null ||
                        filterState[providerKey].isEmpty
                    ? 0.3
                    : 1,
                duration: const Duration(milliseconds: 250),
                child: InkWell(
                  onTap: () {
                    if (filterState[providerKey].isNotEmpty) {
                      ref.read(provider.notifier).state = {
                        ...ref.read(provider),
                        providerKey: "",
                      };
                    }
                  },
                  child: const Icon(Icons.clear, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPickerWidget extends ConsumerWidget {
  final StateProvider<Map<String, dynamic>> provider;
  final String providerKey;

  const CustomPickerWidget({
    super.key,
    required this.provider,
    required this.providerKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FixedExtentScrollController dayController = FixedExtentScrollController(
      initialItem: int.parse(ref.read(provider)[providerKey].split("-")[0]) - 1,
    );
    FixedExtentScrollController monthController = FixedExtentScrollController(
      initialItem: int.parse(ref.read(provider)[providerKey].split("-")[1]) - 1,
    );
    FixedExtentScrollController yearController = FixedExtentScrollController(
      initialItem:
          int.parse(ref.read(provider)[providerKey].split("-")[2]) - 1900,
    );

    return Container(
      color: Colors.white,
      child: FractionallySizedBox(
        heightFactor: 0.3,
        child: Row(
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  Map<String, dynamic> filterState = ref.watch(provider);
                  return CupertinoPicker(
                    scrollController: dayController,
                    itemExtent: 32,
                    onSelectedItemChanged: (value) {
                      List<String> currentDate = ref
                          .read(provider)[providerKey]
                          .split("-");
                      ref.read(provider.notifier).state = {
                        ...ref.read(provider),
                        providerKey:
                            "${value + 1}-${currentDate[1]}-${currentDate[2]}",
                      };
                    },
                    children: [
                      for (
                        int i = 1;
                        i <=
                            DateUtils.getDaysInMonth(
                              int.parse(filterState[providerKey].split("-")[2]),
                              int.parse(filterState[providerKey].split("-")[1]),
                            );
                        i++
                      )
                        Center(child: Text(i.toString())),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: monthController,
                itemExtent: 32,
                onSelectedItemChanged: (value) {
                  List<String> currentDate = ref
                      .read(provider)[providerKey]
                      .split("-");

                  if (DateUtils.getDaysInMonth(
                        int.parse(currentDate[2]),
                        value + 1,
                      ) <
                      int.parse(currentDate[0])) {
                    ref.read(provider.notifier).state = {
                      ...ref.read(provider),
                      providerKey:
                          "${DateUtils.getDaysInMonth(int.parse(currentDate[2]), value + 1)}-${value + 1}-${currentDate[2]}",
                    };
                  } else {
                    ref.read(provider.notifier).state = {
                      ...ref.read(provider),
                      providerKey:
                          "${currentDate[0]}-${value + 1}-${currentDate[2]}",
                    };
                  }
                },
                children: [
                  for (int i = 0; i < 12; i++)
                    Center(
                      child: Text(
                        DateFormat('MMMM', 'da_dk').format(DateTime(0, i + 1)),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: yearController,
                itemExtent: 32,
                onSelectedItemChanged: (value) {
                  List<String> currentDate = ref
                      .read(provider)[providerKey]
                      .split("-");
                  ref.read(provider.notifier).state = {
                    ...ref.read(provider),
                    providerKey:
                        "${currentDate[0]}-${currentDate[1]}-${1900 + value}",
                  };
                },
                children: [
                  for (int i = 0; i <= 200; i++)
                    Center(child: Text((1900 + i).toString())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
