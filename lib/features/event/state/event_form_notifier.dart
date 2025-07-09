import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/event.dart';
import 'package:daily/features/event/data/event_repo.dart';
import 'package:daily/features/event/event_screen.dart';
import 'package:daily/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

part 'event_form_state.dart';

class EventFormNotifier extends AutoDisposeNotifier<EventFormState> {
  @override
  EventFormState build() {
    final now = DateTime.now();
    final nowTime = TimeOfDay.now();
    return EventFormState(
      date: now,
      startTime: nowTime,
      endTime: nowTime.replacing(
          hour: (nowTime.minute + 30) % 60 != (nowTime.minute + 30)
              ? nowTime.hour + 1
              : null,
          minute: (nowTime.minute + 30) % 60),
      useOccurrences: true,
      title: '',
      description: '',
      repeatFrequency: null,
    );
  }

  void init(EventEntity event) {
    state = state.copyWith(
      date: event.date,
      startTime: TimeOfDay.fromDateTime(event.startTime),
      endTime: TimeOfDay.fromDateTime(event.endTime),
      title: event.title,
      description: event.description,
      repeatFrequency: event.repeatFrequency,
      occurrences: event.occurrences,
      endDate: event.endDate,
    );
  }

  void toggleNotification(bool value) =>
      state = state.copyWith(enableNotifications: value);
  void setError(String? message) =>
      state = state.copyWith(errorMessage: message, isLoading: false);

  void setDate(DateTime d) => state = state.copyWith(date: d);
  void setStartTime(TimeOfDay t) => state = state.copyWith(startTime: t);
  void setEndTime(TimeOfDay t) => state = state.copyWith(endTime: t);
  void toggleUseOccurrences(bool b) =>
      state = state.copyWith(useOccurrences: b);
  void setOccurrences(int? count) => state = state.copyWith(occurrences: count);
  void setEndDate(DateTime d) => state = state.copyWith(endDate: d);
  void setTitle(String t) => state = state.copyWith(title: t);
  void setDescription(String d) => state = state.copyWith(description: d);
  void setRepeatFrequency(RepeatFrequency? r) =>
      state = state.copyWith(repeatFrequency: r);

  Future<void> submit({
    required BuildContext context,
    required String? userId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      if (userId == null) {
        throw HiveError("User not logged in");
      }
      final event = EventEntity(
        userId: userId,
        title: state.title,
        description: state.description,
        date: state.date,
        startTime: state.date.copyWith(
            hour: state.startTime.hour, minute: state.startTime.minute),
        endTime: state.date
            .copyWith(hour: state.endTime.hour, minute: state.endTime.minute),
        repeatFrequency: state.repeatFrequency,
        occurrences: state.useOccurrences ? state.occurrences : null,
        endDate: state.useOccurrences ? null : state.endDate,
      );

      ref.read(eventRepoProvider).addEvent(event);
      ref.read(eventControllerProvider).add(event.eventData);
      if (state.enableNotifications) {
        NotifyService().scheduleNotification(
            title: event.title,
            body: "Event is going to start",
            time: event.startTime);
      }
      state = state.copyWith(isLoading: false);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> update({
    required BuildContext context,
    required EventEntity event,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final updatedEvent = EventEntity(
        userId: event.userId,
        title: state.title,
        description: state.description,
        date: state.date,
        startTime: state.date.copyWith(
            hour: state.startTime.hour, minute: state.startTime.minute),
        endTime: state.date
            .copyWith(hour: state.endTime.hour, minute: state.endTime.minute),
        repeatFrequency: state.repeatFrequency,
        occurrences: state.useOccurrences ? state.occurrences : null,
        endDate: state.useOccurrences ? null : state.endDate,
      );

      ref.read(eventRepoProvider).updateEvent(
            event,
            title: state.title,
            description: state.description,
            date: state.date,
            startTime: state.date.copyWith(
                hour: state.startTime.hour, minute: state.startTime.minute),
            endTime: state.date.copyWith(
                hour: state.endTime.hour, minute: state.endTime.minute),
            repeatFrequency: state.repeatFrequency,
            occurrences: state.useOccurrences ? state.occurrences : null,
            endDate: state.useOccurrences ? null : state.endDate,
          );

      ref
          .read(eventControllerProvider)
          .update(event.eventData, updatedEvent.eventData);

      state = state.copyWith(isLoading: false);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> delete({
    required BuildContext context,
    required EventEntity event,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      ref.read(eventRepoProvider).deleteEvent(event);
      ref.read(eventControllerProvider).remove(event.eventData);

      state = state.copyWith(isLoading: false);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
