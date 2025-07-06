import 'package:calendar_view/calendar_view.dart';
import 'package:daily/features/event/state/event_form_notifier.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _eventNotifierProvider =
    NotifierProvider.autoDispose<EventFormNotifier, EventFormState>(
        EventFormNotifier.new);

class NewEventScreen extends ConsumerWidget {
  const NewEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(_eventNotifierProvider);
    final notifier = ref.read(_eventNotifierProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (form.errorMessage != null && context.mounted) {
        showErrorSnackbar(context, form.errorMessage!);
        notifier.setError(null);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            await showConfirmationDialog(
                    context: context,
                    title: "Event data will not be saved",
                    content: "Do you want to discard the event?")
                .then(
              (value) {
                if (value != null && value && context.mounted) {
                  Navigator.pop(context);
                }
              },
            );
          },
        ),
        title: const Text("New Event"),
        actions: [
          form.isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  onPressed: () async {
                    final result = await showConfirmationDialog(
                      context: context,
                      title: "Do you want to save this event?",
                    );
                    if (result != null && context.mounted) {
                      if (result) {
                        notifier.submit(
                          context: context,
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.done),
                )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 14,
          children: [
            Row(
              spacing: 12,
              children: [
                const Icon(Icons.create),
                Flexible(
                  child: TextField(
                    onChanged: (value) => notifier.setTitle(value),
                    decoration: const InputDecoration(hintText: "Title"),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Icon(Icons.access_time),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: form.date,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2050),
                    ).then((selectedDate) {
                      final endDate = form.endDate;
                      if (selectedDate != null && context.mounted) {
                        if (endDate == null) {
                          notifier.setDate(selectedDate);
                        } else if (selectedDate.isBefore(endDate) &&
                            !form.useOccurrences) {
                          showErrorSnackbar(context, "End date");
                          return;
                        }
                        notifier.setDate(selectedDate);
                      }
                    });
                  },
                  child: Text(DateFormat.yMMMd().format(form.date)),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await showTimePicker(
                          context: context,
                          initialTime: form.startTime,
                        ).then(
                          (selectedTime) {
                            final endTime = form.endTime;
                            if (selectedTime != null) {
                              if (selectedTime.isAfter(endTime) &&
                                  context.mounted) {
                                showErrorSnackbar(context,
                                    "End time must be after start time");
                                return;
                              }
                              notifier.setStartTime(selectedTime);
                            }
                          },
                        );
                      },
                      child: Text(form.startTime.format(context)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await showTimePicker(
                                context: context, initialTime: form.endTime)
                            .then(
                          (selectedTime) {
                            final startTime = form.startTime;
                            if (selectedTime != null) {
                              if (selectedTime.isBefore(startTime) &&
                                  context.mounted) {
                                showErrorSnackbar(context,
                                    "End time must be after start time");
                                return;
                              }
                              notifier.setEndTime(selectedTime);
                            }
                          },
                        );
                      },
                      child: Text(form.endTime.format(context)),
                    ),
                  ],
                )
              ],
            ),
            Row(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: const Icon(Icons.repeat),
                ),
                Flexible(
                  child: DropdownMenu<RepeatFrequency>(
                      initialSelection: RepeatFrequency.doNotRepeat,
                      onSelected: (value) => notifier.setRepeatFrequency(value),
                      helperText: "Repeat",
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                            value: RepeatFrequency.doNotRepeat,
                            label: "Don't repeat"),
                        DropdownMenuEntry(
                            value: RepeatFrequency.daily, label: "Daily"),
                        DropdownMenuEntry(
                            value: RepeatFrequency.monthly, label: "Monthly"),
                        DropdownMenuEntry(
                            value: RepeatFrequency.weekly, label: "Weekly"),
                        DropdownMenuEntry(
                            value: RepeatFrequency.yearly, label: "Yearly"),
                      ]),
                ),
                Flexible(child: Toggle())
              ],
            ),
            Row(
              spacing: 12,
              children: [
                const Icon(Icons.notifications),
                Switch(
                  value: form.enableNotifications,
                  onChanged: (value) => notifier.toggleNotification(value),
                ),
                Text("Enable notifications"),
              ],
            ),
            Row(
              spacing: 12,
              children: [
                const Icon(Icons.notes),
                Flexible(
                  child: TextField(
                    onChanged: (value) => notifier.setDescription(value),
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Toggle extends ConsumerWidget {
  const Toggle({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 6,
      children: [
        Row(
          children: [
            Radio(
              value: true,
              groupValue: ref.watch(_eventNotifierProvider).useOccurrences,
              onChanged: (_) {
                ref
                    .read(_eventNotifierProvider.notifier)
                    .toggleUseOccurrences(true);
              },
            ),
            SizedBox(
                width: 100,
                height: 60,
                child: TextField(
                  onChanged: (value) => ref
                      .read(_eventNotifierProvider.notifier)
                      .setOccurrences(int.tryParse(value)),
                  enabled: ref.watch(_eventNotifierProvider).useOccurrences,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  cursorHeight: 20,
                  decoration: const InputDecoration(
                    counterText: "Occurence",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  ),
                )),
          ],
        ),
        Row(
          children: [
            Radio(
              value: false,
              groupValue: ref.watch(_eventNotifierProvider).useOccurrences,
              onChanged: (_) {
                ref
                    .read(_eventNotifierProvider.notifier)
                    .toggleUseOccurrences(false);
              },
            ),
            SizedBox(
                width: 100,
                child: InputDecorator(
                  decoration: InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    counterText: "End Date",
                    contentPadding: EdgeInsets.all(0.0),
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  child: ElevatedButton(
                      onPressed: ref
                              .watch(_eventNotifierProvider)
                              .useOccurrences
                          ? null
                          : () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2050),
                              ).then((selectedDate) {
                                final endDate =
                                    ref.read(_eventNotifierProvider).endDate;
                                if (selectedDate != null && context.mounted) {
                                  if (endDate == null) {
                                    ref
                                        .read(_eventNotifierProvider.notifier)
                                        .setDate(selectedDate);
                                  } else if (selectedDate.isBefore(endDate) &&
                                      !ref
                                          .read(_eventNotifierProvider)
                                          .useOccurrences) {
                                    showErrorSnackbar(context, "End date");
                                    return;
                                  }
                                  ref
                                      .read(_eventNotifierProvider.notifier)
                                      .setDate(selectedDate);
                                }
                              });
                            },
                      child: Text(
                        "End Date",
                        style: FontsDaily.subText,
                      )),
                ))
          ],
        ),
      ],
    );
  }
}
