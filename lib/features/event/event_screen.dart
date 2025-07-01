import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/event.dart';
import 'package:daily/features/event/data/event_repo.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/week_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_screen.g.dart';

@riverpod
EventController eventController(ref) {
  return EventController();
}

@riverpod
Stream<List<EventEntity>> userEvents(Ref ref, String userId) async* {
  final box = ref.watch(eventRepoProvider).box;

  // Emit initial list
  yield box.values.where((e) => e.userId == userId).toList();

  // Then yield updated lists on every change
  await for (final _ in box.watch()) {
    yield box.values.where((e) => e.userId == userId).toList();
  }
}

class EventScreen extends ConsumerWidget {
  EventScreen({super.key});

  final GlobalKey<DayViewState> dayState = GlobalKey<DayViewState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(eventControllerProvider);
    final eventsAsync = ref.watch(userEventsProvider("Ujan"));

    return CalendarControllerProvider(
      controller: controller,
      child: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading events')),
        data: (events) {
          // Add events after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.removeWhere((_) => true); // Clear previous events
            controller.addAll(events.map((e) => e.eventData).toList());
          });

          return Column(
            children: [
              WeekTabBar(onDateSelected: (selected) {
                dayState.currentState?.jumpToDate(selected);
              }),
              Expanded(
                child: DayView(
                  key: dayState,
                  minDay: DateTime(2024),
                  maxDay: DateTime(2050),
                  eventArranger: SideEventArranger(),
                  onEventTap: (events, date) => print(events),
                  onEventDoubleTap: (events, date) => print(events),
                  onEventLongTap: (events, date) => print(events),
                  onDateLongPress: (date) => print(date),
                  dayTitleBuilder: (date) => DayPageHeader(
                    date: date,
                    headerStyle: HeaderStyle(
                      headerTextStyle: FontsDaily.bigTitle,
                    ),
                  ),
                  keepScrollOffset: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
