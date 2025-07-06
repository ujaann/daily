import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Providers
final amountProvider = StateProvider.autoDispose<String>((ref) => '0');
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

class CustomKeyboard extends ConsumerWidget {
  final bool Function() onSubmit;
  const CustomKeyboard({required this.onSubmit, super.key});

  void appendToAmount(WidgetRef ref, String char) {
    final current = ref.read(amountProvider);
    if (char == '.' && current.contains('.')) return;

    final newVal = current == '0' && char != '.' ? char : current + char;
    ref.read(amountProvider.notifier).state = newVal;
  }

  void appendDecimal(WidgetRef ref) {
    final current = ref.read(amountProvider);
    final data = current.split('');
    int? last;

    for (var i = 0; i < data.length; i++) {
      if (data.elementAt(i) == '.') {
        last = i;
      } else if (data.elementAt(i) == '-' || data.elementAt(i) == '+') {
        last = null;
      }
    }
    if (last == null) {
      ref.read(amountProvider.notifier).state = '$current.';
    } else if (current.endsWith('.')) {
      ref.read(amountProvider.notifier).state =
          current.substring(0, current.length - 1);
    }
  }

  void appendSign(WidgetRef ref, String char) {
    final current = ref.read(amountProvider);
    switch (char) {
      case '+':
        if (current.endsWith('+')) {
          ref.read(amountProvider.notifier).state =
              current.substring(0, current.length - 1);
        } else if (current.endsWith('-') || current.endsWith('.')) {
          ref.read(amountProvider.notifier).state =
              '${current.substring(0, current.length - 1)}+';
        } else {
          ref.read(amountProvider.notifier).state = '$current$char';
        }
        return;
      case '-':
        if (current.endsWith('-')) {
          ref.read(amountProvider.notifier).state =
              current.substring(0, current.length - 1);
        } else if (current.endsWith('+') || current.endsWith('.')) {
          ref.read(amountProvider.notifier).state =
              '${current.substring(0, current.length - 1)}-';
        } else {
          ref.read(amountProvider.notifier).state = '$current$char';
        }
        return;

      default:
        return;
    }
  }

  void backspace(WidgetRef ref) {
    final current = ref.read(amountProvider);
    final newVal =
        current.length <= 1 ? '0' : current.substring(0, current.length - 1);
    ref.read(amountProvider.notifier).state = newVal;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(amountProvider);
    final noteController = ref.watch(noteControllerProvider);
    final showKeyboard = ref.watch(showCustomKeyboardProvider);

    final buttons = <String, VoidCallback>{
      '7': () => appendToAmount(ref, '7'),
      '8': () => appendToAmount(ref, '8'),
      '9': () => appendToAmount(ref, '9'),
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
      '4': () => appendToAmount(ref, '4'),
      '5': () => appendToAmount(ref, '5'),
      '6': () => appendToAmount(ref, '6'),
      '+': () => appendSign(ref, '+'),
      '1': () => appendToAmount(ref, '1'),
      '2': () => appendToAmount(ref, '2'),
      '3': () => appendToAmount(ref, '3'),
      '-': () => appendSign(ref, '-'),
      '.': () => appendDecimal(ref),
      '0': () => appendToAmount(ref, '0'),
      '«': () => backspace(ref),
      '✓': () async {
        await showConfirmationDialog(context: context, title: "Record expense?")
            .then(
          (confirm) {
            if (confirm != null && confirm && context.mounted) {
              final submitted = onSubmit();
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
                    style: ElevatedButton.styleFrom(
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
