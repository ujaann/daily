import 'package:daily/theme/theme_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
final amountProvider = StateProvider.autoDispose<String>((ref) => '0');

final noteControllerProvider =
    StateProvider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final showCustomKeyboardProvider =
    StateProvider.autoDispose<bool>((ref) => true);

class CustomKeyboard extends ConsumerWidget {
  const CustomKeyboard({super.key});

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
      'today': () => noteController.text = 'Today',
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
      '✓': () {
        final result =
            'Note: ${noteController.text} | Amount: ${ref.read(amountProvider)}';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Submitted: $result')));
      },
    };

    return ColoredBox(
      color: const Color(0xFF2E2E2E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Text(
            amount,
            textAlign: TextAlign.right,
            style: const TextStyle(color: ColorsDaily.white, fontSize: 32),
          ),

          const SizedBox(height: 12),

          // Wrap in Focus widget to detect focus change
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Focus(
              onFocusChange: (hasFocus) {
                // Hide custom keyboard when note is focused
                ref.read(showCustomKeyboardProvider.notifier).state = !hasFocus;
              },
              child: TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: "Note",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Conditionally show custom keyboard
          if (showKeyboard)
            SizedBox(
              height: 270,
              width: double.infinity,
              child: GridView.count(
                padding: const EdgeInsets.all(12),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                crossAxisCount: 4,
                childAspectRatio: 2,
                children: buttons.entries.map((entry) {
                  return ElevatedButton(
                    onPressed: entry.value,
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
