import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingButtonControllerProvider = StateNotifierProvider.family<
    LoadingButtonController,
    AsyncValue<void>,
    Future<void> Function()>((ref, callback) {
  return LoadingButtonController(callback: callback);
});

class StatedButton extends StatelessWidget {
  const StatedButton(
      {super.key, required this.text, this.isLoading = false, this.onPressed});
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: isLoading ? const CircularProgressIndicator() : Text(text),
    );
  }
}

class LoadingButton extends ConsumerWidget {
  const LoadingButton({super.key, required this.callback, required this.text});
  final Future<void> Function() callback;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      loadingButtonControllerProvider(callback),
      (_, state) => state.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      ),
    );

    // 2. use the loading state in the child widget
    final loadingState = ref.watch(loadingButtonControllerProvider(callback));
    final isLoading = loadingState is AsyncLoading<void>;

    return StatedButton(
        isLoading: isLoading,
        onPressed: isLoading
            ? null
            : () => ref
                .read(loadingButtonControllerProvider(callback).notifier)
                .callback(),
        text: text);
  }
}

class LoadingButtonController extends StateNotifier<AsyncValue<void>> {
  LoadingButtonController({required this.callback})
      // initialize state
      : super(const AsyncValue.data(null));
  final Future<void> Function() callback;

  Future<void> executeCallback() async {
    try {
      // set state to `loading` before starting the asynchronous work
      state = const AsyncValue.loading();
      // do the async work
      await callback();
    } catch (e) {
      // if the payment failed, set the error state
      state =
          AsyncValue.error('$callback execution failed', StackTrace.current);
    } finally {
      // set state to `data(null)` at the end (both for success and failure)
      state = const AsyncValue.data(null);
    }
  }
}
