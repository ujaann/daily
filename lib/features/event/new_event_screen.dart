import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/event.dart';
import 'package:daily/features/event/data/event_repo.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _dateProvider = StateProvider.autoDispose<DateTime>((ref) {
  return DateTime.now();
});
final _startTimeProvider = StateProvider.autoDispose<TimeOfDay>((ref) {
  return TimeOfDay(hour: 12, minute: 10);
});
final _endTimeProvider = StateProvider.autoDispose<TimeOfDay>((ref) {
  final time = ref.read(_startTimeProvider);
  return time.replacing(
      hour:
          (time.minute + 30) % 60 != (time.minute + 30) ? time.hour + 1 : null,
      minute: (time.minute + 30) % 60);
});

final _titleControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(
    () {
      print("title disposed");
      controller.dispose();
    },
  );
  return controller;
});
final _descriptionControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(
    () {
      controller.dispose();
    },
  );
  return controller;
});

class NewEventScreen extends ConsumerWidget {
  const NewEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = ref.watch(_titleControllerProvider);
    final descriptionController = ref.watch(_descriptionControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("New Event"),
        actions: [
          IconButton(
              onPressed: () {
                ref.watch(eventRepoProvider).addEvent(
                      EventEntity(
                          userId: "Ujan",
                          title: "title",
                          date: DateTime.now(),
                          startTime: TimeOfDay(hour: 1, minute: 10),
                          endTime: TimeOfDay(hour: 2, minute: 10),
                          description: '',
                          recurrenceSettings: null),
                    );
              },
              icon: Icon(Icons.done))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
        child: Column(
          spacing: 14,
          children: [
            Row(
              spacing: 12,
              children: [
                Icon(Icons.create),
                Flexible(
                    child: TextField(
                  decoration: InputDecoration(hintText: "Title"),
                  controller: titleController,
                ))
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
                  child:
                      Text(DateFormat.yMMMd().format(ref.watch(_dateProvider))),
                  onPressed: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2050),
                    ).then((selectedDate) {
                      if (selectedDate != null && context.mounted) {
                        if (selectedDate.isBefore(ref.read(_endDateProvider)) &&
                            !ref.read(_selectedOccurenceOrEndDate)) {
                          showErrorSnackbar(context, "End date");
                          return;
                        }
                        ref.watch(_dateProvider.notifier).state = selectedDate;
                      }
                    });
                  },
                ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await showTimePicker(
                                  context: context,
                                  initialTime: ref.read(_startTimeProvider))
                              .then(
                            (selectedTime) {
                              if (selectedTime != null) {
                                if (selectedTime
                                        .isAfter(ref.read(_endTimeProvider)) &&
                                    context.mounted) {
                                  showErrorSnackbar(context,
                                      "End time must be after start time");
                                  return;
                                }

                                ref.read(_startTimeProvider.notifier).state =
                                    selectedTime;
                              }
                            },
                          );
                        },
                        child: Text(
                            ref.watch(_startTimeProvider).format(context))),
                    ElevatedButton(
                        onPressed: () async {
                          await showTimePicker(
                                  context: context,
                                  initialTime: ref.read(_endTimeProvider))
                              .then(
                            (selectedTime) {
                              if (selectedTime != null) {
                                if (selectedTime.isBefore(
                                        ref.read(_startTimeProvider)) &&
                                    context.mounted) {
                                  showErrorSnackbar(context,
                                      "End time must be after start time");
                                  return;
                                }

                                ref.read(_endTimeProvider.notifier).state =
                                    selectedTime;
                              }
                            },
                          );
                        },
                        child:
                            Text(ref.watch(_endTimeProvider).format(context))),
                  ],
                )
              ],
            ),
            Row(
              spacing: 12,
              children: [
                Icon(Icons.repeat),
                DropdownMenu<RepeatFrequency>(
                    initialSelection: RepeatFrequency.daily,
                    helperText: "Repeat",
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                          value: RepeatFrequency.doNotRepeat,
                          label: "Do Not repeat"),
                      DropdownMenuEntry(
                          value: RepeatFrequency.daily, label: "Daily"),
                      DropdownMenuEntry(
                          value: RepeatFrequency.monthly, label: "Monthly"),
                      DropdownMenuEntry(
                          value: RepeatFrequency.weekly, label: "Weekly"),
                      DropdownMenuEntry(
                          value: RepeatFrequency.yearly, label: "Yearly"),
                    ]),
                Toggle()
              ],
            ),
            Row(
              spacing: 12,
              children: [
                Icon(Icons.notes),
                Flexible(
                    child: TextField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(hintText: "Description"),
                  controller: descriptionController,
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final _endDateProvider = StateProvider.autoDispose<DateTime>((ref) {
  return DateTime.now();
});

final _occurenceControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final _selectedOccurenceOrEndDate = StateProvider<bool>((ref) {
  return true;
});

class Toggle extends ConsumerWidget {
  const Toggle({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Radio(
              value: true,
              groupValue: ref.watch(_selectedOccurenceOrEndDate),
              onChanged: (_) {
                ref.read(_selectedOccurenceOrEndDate.notifier).state = true;
              },
            ),
            SizedBox(
                width: 100,
                height: 40,
                child: TextField(
                  enabled: ref.watch(_selectedOccurenceOrEndDate),
                  controller: ref.watch(_occurenceControllerProvider),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  cursorHeight: 20,
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 6)),
                )),
          ],
        ),
        Row(
          children: [
            Radio(
              value: false,
              groupValue: ref.watch(_selectedOccurenceOrEndDate),
              onChanged: (_) {
                ref.read(_selectedOccurenceOrEndDate.notifier).state = false;
              },
            ),
            SizedBox(
                width: 100,
                child: ElevatedButton(
                    onPressed:
                        ref.watch(_selectedOccurenceOrEndDate) ? null : () {},
                    child: Text(
                      "End Date",
                      style: FontsDaily.subText,
                    )))
          ],
        ),
      ],
    );
  }
}
