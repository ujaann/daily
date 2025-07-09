import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/custom_keyboard/calc_notifier.dart';
import 'package:daily/util/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Providers

final newExpenseDateProvider =
    StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
final noteControllerProvider =
    StateProvider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() => controller.dispose());
  return controller;
});
final showCustomKeyboardProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final calcNotfierProvider =
    AutoDisposeNotifierProvider<CalcNotifier, String>(CalcNotifier.new);

class CustomKeyboard extends ConsumerWidget {
  final bool Function() onSubmit;
  const CustomKeyboard({required this.onSubmit, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(calcNotfierProvider);
    final calcNotifier = ref.read(calcNotfierProvider.notifier);
    final noteController = ref.watch(noteControllerProvider);
    final showKeyboard = ref.watch(showCustomKeyboardProvider);

    final buttons = <String, VoidCallback>{
      '7': () => calcNotifier.inputNumbers('7'),
      '8': () => calcNotifier.inputNumbers('8'),
      '9': () => calcNotifier.inputNumbers('9'),
      'Date': () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: ref.read(newExpenseDateProvider),
          firstDate: DateTime(2024),
          lastDate: DateTime(2050),
        );
        if (selectedDate != null) {
          ref.read(newExpenseDateProvider.notifier).state = selectedDate;
        }
      },
      '4': () => calcNotifier.inputNumbers('4'),
      '5': () => calcNotifier.inputNumbers('5'),
      '6': () => calcNotifier.inputNumbers('6'),
      '+': () => calcNotifier.inputOperator('+'),
      '1': () => calcNotifier.inputNumbers('1'),
      '2': () => calcNotifier.inputNumbers('2'),
      '3': () => calcNotifier.inputNumbers('3'),
      '-': () => calcNotifier.inputOperator('-'),
      '.': () => calcNotifier.decimalPoint(),
      '0': () => calcNotifier.inputNumbers('0'),
      '«': () => calcNotifier.backspace(),
      '✓': () async {
        await showConfirmationDialog(context: context, title: "Record expense?")
            .then(
          (confirm) {
            calcNotifier.getValue();

            if (confirm != null && confirm && context.mounted) {
              final submitted = onSubmit();
              print(amount);
              if (submitted) {
                Navigator.pop(context);
              }
            }
          },
        );
      },
    };

    return ColoredBox(
      color: ColorsDaily.white70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Text(
              amount,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 32),
            ),
          ),

          const SizedBox(height: 12),

          // Wrap in Focus widget to detect focus change
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Focus(
              onFocusChange: (hasFocus) {
                // Hide custom keyboard when note is focused
                Future.delayed(
                  Durations.short4,
                  () => ref.read(showCustomKeyboardProvider.notifier).state =
                      !hasFocus,
                );
              },
              child: TextField(
                controller: noteController,
                onTapAlwaysCalled: true,
                onTapOutside: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                decoration: InputDecoration(
                  hintText: "Note",
                  counterText: DateFormat.yMMMd()
                      .format(ref.watch(newExpenseDateProvider)),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),

          // Conditionally show custom keyboard
          if (showKeyboard)
            SizedBox(
              height: 270,
              width: double.infinity,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                crossAxisCount: 4,
                childAspectRatio: 2,
                children: buttons.entries.map((entry) {
                  return ElevatedButton(
                    onPressed: entry.value,
                    style: (entry.key == '✓' || entry.key == 'Date')
                        ? null
                        : ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: ColorsDaily.black,
                          ),
                    child: Text(
                      entry.key,
                      style: FontsDaily.titleSubText
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
