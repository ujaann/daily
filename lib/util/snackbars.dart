import 'package:daily/theme/theme_common.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<DateTime?> showDailyMonthPicker({
  required BuildContext context,
  DateTime? initialDate,
}) {
  return showMonthPicker(
      context: context,
      firstDate: DateTime(2024),
      initialDate: initialDate,
      lastDate: DateTime(2050),
      monthPickerDialogSettings: MonthPickerDialogSettings(
          dateButtonsSettings: PickerDateButtonsSettings(
            selectedMonthBackgroundColor: ColorsDaily.darkgray,
          ),
          headerSettings:
              PickerHeaderSettings(headerBackgroundColor: ColorsDaily.green),
          dialogSettings: PickerDialogSettings(
            dialogRoundedCornersRadius: 12,
          )));
}

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  String? content,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: content == null ? null : Text(content),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false), // Return false
          child: const Text("No"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true), // Return true
          child: const Text("Yes"),
        ),
      ],
    ),
  );
}

showLoadingDialog(
  BuildContext context,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: const CircularProgressIndicator(
          constraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
        ),
      ),
    ),
  );
}
