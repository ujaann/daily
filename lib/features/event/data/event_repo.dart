import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/event.dart';
import 'package:daily/hive/hive_boxes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_repo.g.dart';

@riverpod
Box<EventEntity> _eventBox(Ref ref) {
  return Hive.box<EventEntity>(HiveBoxes.eventBox);
}

@riverpod
EventRepo eventRepo(Ref ref) {
  final box = ref.watch(_eventBoxProvider);
  return EventRepo(box);
}

class EventRepo {
  final Box<EventEntity> box;

  EventRepo(this.box);

  List<EventEntity> getEvents(String userId) {
    return box.values.where((e) => e.userId == userId).toList();
  }

  void addEvent(EventEntity event) {
    box.add(event);
  }

  Future<void> deleteEvent(EventEntity event) async {
    await box.delete(event.key);
  }

  Future<void> updateEvent(
    EventEntity event, {
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? date,
    String? userId,
    String? description,
    RepeatFrequency? repeatFrequency,
    int? occurrences,
    DateTime? endDate,
    // Add other fields as needed
  }) async {
    final updatedEvent = event.copyWith(
      title: title ?? event.title,
      startTime: startTime ?? event.startTime,
      endTime: endTime ?? event.endTime,
      description: description ?? event.description,
      repeatFrequency: repeatFrequency ?? event.repeatFrequency,
      occurrences: occurrences ?? event.occurrences,
      endDate: endDate ?? event.endDate,

      userId: userId,
      // Add other fields as needed
    );
    await box.put(event.key, updatedEvent);
  }
}
