import 'package:calendar_view/calendar_view.dart';
import 'package:hive_ce/hive.dart';

class EventEntity extends HiveObject {
  final String userId;
  final String title;
  final String description;

  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final RepeatFrequency? repeatFrequency;
  final int? occurrences;
  final DateTime? endDate;

  CalendarEventData<int?> get eventData => CalendarEventData<int?>(
        date: date,
        title: title,
        startTime: startTime,
        endTime: endTime,
        recurrenceSettings: repeatFrequency != null
            ? RecurrenceSettings.withCalculatedEndDate(
                startDate: date, occurrences: occurrences, endDate: endDate)
            : null,
        description: description,
        event: key,
      );

  EventEntity({
    required this.description,
    required this.repeatFrequency,
    required this.occurrences,
    required this.endDate,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.userId,
  });

  EventEntity copyWith({
    String? userId,
    String? title,
    String? description,
    RecurrenceSettings? recurrenceSettings,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    RepeatFrequency? repeatFrequency,
    int? occurrences,
    DateTime? endDate,
  }) {
    return EventEntity(
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      repeatFrequency: repeatFrequency ?? this.repeatFrequency,
      occurrences: occurrences ?? this.occurrences,
      endDate: endDate ?? this.endDate,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
