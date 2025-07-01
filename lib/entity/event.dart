import 'package:calendar_view/calendar_view.dart';
import 'package:hive_ce/hive.dart';

class EventEntity extends HiveObject {
  final String userId;
  final CalendarEventData eventData;

  EventEntity({
    required this.userId,
    required this.eventData,
  });

  EventEntity copyWith({
    String? userId,
    CalendarEventData? eventData,
  }) =>
      EventEntity(
        userId: userId ?? this.userId,
        eventData: eventData ?? this.eventData,
      );
}
