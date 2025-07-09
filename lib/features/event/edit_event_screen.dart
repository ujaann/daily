import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/event.dart';
import 'package:daily/features/event/data/event_repo.dart';
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

final readOnlyProvider = StateProvider.autoDispose<bool>((ref) => true);

class EditEventScreen extends ConsumerStatefulWidget {
  const EditEventScreen({super.key, required this.event});
  final EventEntity event;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  bool _initialized = false;
  @override
  void initState() {
    Future.microtask(() {
      if (!_initialized) {
        ref.read(_eventNotifierProvider.notifier).init(widget.event);
        _initialized = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final form = ref.watch(_eventNotifierProvider);

    final notifier = ref.read(_eventNotifierProvider.notifier);

    print(form.startTime);
    final readOnly = ref.watch(readOnlyProvider);

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
            if (readOnly) {
              Navigator.pop(context);
              return;
            }
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
        title: const Text("Edit Event"),
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
                      title: "Do you want to update this event?",
                    );
                    if (result != null && context.mounted) {
                      if (result) {
                        notifier.update(
                          context: context,
                          event: widget.event,
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
                  child: TextFormField(
                    initialValue: widget.event.title,
                    onChanged:
                        readOnly ? null : (value) => notifier.setTitle(value),
                    enabled: !readOnly,
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
                  onPressed: readOnly
                      ? null
                      : () async {
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
                      onPressed: readOnly
                          ? null
                          : () async {
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
                      onPressed: readOnly
                          ? null
                          : () async {
                              await showTimePicker(
                                      context: context,
                                      initialTime: form.endTime)
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
                      onSelected: readOnly
                          ? null
                          : (value) => notifier.setRepeatFrequency(value),
                      enabled: !readOnly,
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
                Flexible(
                    child: Toggle(
                  readOnly: readOnly,
                  occurence: widget.event.occurrences ?? 0,
                ))
              ],
            ),
            Row(
              spacing: 12,
              children: [
                const Icon(Icons.notes),
                Flexible(
                  child: TextFormField(
                    initialValue: widget.event.description,
                    onChanged: readOnly
                        ? null
                        : (value) => notifier.setDescription(value),
                    enabled: !readOnly,
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 24,
              children: [
                SizedBox(
                    width: 160,
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () async {
                          await showConfirmationDialog(
                                  context: context,
                                  title: "Do you want to delete the record?")
                              .then(
                            (value) async {
                              if (value != null && value) {
                                await ref
                                    .read(eventRepoProvider)
                                    .deleteEvent(widget.event);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                          );
                        },
                        child: Text(
                          "Delete",
                          style: FontsDaily.titleSubText,
                        ))),
                SizedBox(
                    width: 160,
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () =>
                            ref.read(readOnlyProvider.notifier).state = false,
                        child: Text(
                          "Edit",
                          style: FontsDaily.titleSubText,
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Toggle extends ConsumerWidget {
  final bool readOnly;
  final int occurence;
  const Toggle({super.key, this.readOnly = false, this.occurence = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useOccurrences = ref.watch(_eventNotifierProvider.select(
      (value) => value.useOccurrences,
    ));
    final endDate = ref.watch(_eventNotifierProvider.select(
      (value) => value.endDate,
    ));
    return Column(
      spacing: 6,
      children: [
        Row(
          children: [
            Radio(
              value: true,
              groupValue: useOccurrences,
              onChanged: readOnly
                  ? null
                  : (_) {
                      ref
                          .read(_eventNotifierProvider.notifier)
                          .toggleUseOccurrences(true);
                    },
            ),
            SizedBox(
                width: 100,
                height: 60,
                child: TextFormField(
                  initialValue: occurence.toString(),
                  onChanged: readOnly
                      ? null
                      : (value) => ref
                          .read(_eventNotifierProvider.notifier)
                          .setOccurrences(int.tryParse(value)),
                  enabled: readOnly ? false : useOccurrences,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  cursorHeight: 20,
                  decoration: const InputDecoration(
                    counterText: "Occurence",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  ),
                ))
          ],
        ),
        Row(
          children: [
            Radio(
              value: false,
              groupValue: useOccurrences,
              onChanged: readOnly
                  ? null
                  : (_) {
                      ref
                          .read(_eventNotifierProvider.notifier)
                          .toggleUseOccurrences(false);
                    },
            ),
            Flexible(
                child: InputDecorator(
              decoration: InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.center,
                counterText: "End Date",
                contentPadding: EdgeInsets.all(0.0),
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              child: ElevatedButton(
                  onPressed: ref.watch(_eventNotifierProvider).useOccurrences
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
                                  .setEndDate(selectedDate);
                            }
                          });
                        },
                  child: Text(
                    (endDate == null)
                        ? "End Date"
                        : DateFormat.yMMMd().format(endDate),
                    style: FontsDaily.subText,
                  )),
            ))
          ],
        ),
      ],
    );
  }
}
