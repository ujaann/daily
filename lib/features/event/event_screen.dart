import 'package:calendar_view/calendar_view.dart';
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

class EventScreen extends ConsumerWidget {
  EventScreen({super.key});

  final GlobalKey<DayViewState> dayState = GlobalKey<DayViewState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CalendarControllerProvider(
      controller: ref.watch(eventControllerProvider),
      child: Column(
        children: [
          WeekTabBar(onDateSelected: (selected) {
            dayState.currentState?.jumpToDate(selected);
          }),
          Expanded(
            child: DayView(
              key: dayState,

              minDay: DateTime(2024),
              maxDay: DateTime(2050),

              eventArranger:
                  SideEventArranger(), // To define how simultaneous events will be arranged.
              onEventTap: (events, date) => print(events),
              onEventDoubleTap: (events, date) => print(events),
              onEventLongTap: (events, date) => print(events),
              onDateLongPress: (date) => print(date),

              dayTitleBuilder: (date) => DayPageHeader(
                date: date,
                headerStyle: HeaderStyle(
                  headerTextStyle: FontsDaily.bigTitle,
                ),
              ), // To Hide day header
              keepScrollOffset: true,
            ),
          ),
        ],
      ),
    );
  }
}
