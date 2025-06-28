import 'package:calendar_view/calendar_view.dart';
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
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CalendarControllerProvider(
      controller: ref.watch(eventControllerProvider),
      child: Column(
        children: [
          WeekTabBar(onDateSelected: (_) {}),
          Expanded(
            child: DayView(
              eventTileBuilder: (date, events, boundry, start, end) {
                // Return your widget to display as event tile.
                return Container();
              },
              fullDayEventBuilder: (events, date) {
                // Return your widget to display full day event view.
                return Container();
              },
              showVerticalLine: true, // To display live time line in day view.
              showLiveTimeLineInAllDays:
                  true, // To display live time line in all pages in day view.
              minDay: DateTime(1990),
              maxDay: DateTime(2050),

              eventArranger:
                  SideEventArranger(), // To define how simultaneous events will be arranged.
              onEventTap: (events, date) => print(events),
              onEventDoubleTap: (events, date) => print(events),
              onEventLongTap: (events, date) => print(events),
              onDateLongPress: (date) => print(date),
              // To set the end hour displayed
              // hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset) {
              //     return //Your custom painter.
              // },
              dayTitleBuilder: (date) =>
                  DayPageHeader(date: date), // To Hide day header
              keepScrollOffset: true,
            ),
          ),
        ],
      ),
    );
  }
}
