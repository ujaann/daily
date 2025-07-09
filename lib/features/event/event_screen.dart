import 'package:calendar_view/calendar_view.dart';
import 'package:daily/auth/auth_service.dart';
import 'package:daily/entity/event.dart';
import 'package:daily/features/event/data/event_repo.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/week_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'edit_event_screen.dart';

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
    final controller = ref.watch(eventControllerProvider);
    final box = ref.watch(eventRepoProvider).box;
    final user = ref.watch(authServiceProvider);
    final time = TimeOfDay.now();

    return CalendarControllerProvider(
      controller: controller,
      child: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<EventEntity> box, _) {
          final List<EventEntity> events;
          if (user != null) {
            events =
                box.values.where((e) => e.userId == user.username).toList();
          } else {
            events = [];
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.removeWhere((_) => true);
            controller.addAll(events
                .map(
                  (e) => e.eventData.copyWith(color: ColorsDaily.white70),
                )
                .toList());
          });

          return Column(
            children: [
              WeekTabBar(
                onDateSelected: (selected) {
                  dayState.currentState?.jumpToDate(selected);
                },
              ),
              Expanded(
                child: DayView(
                  key: dayState,
                  controller: controller,
                  scrollOffset: (time.hour * 60 + time.minute) * 1.75 - 20,
                  heightPerMinute: 1.75,
                  startHour: 3,
                  endHour: 23,
                  minDay: DateTime(2024),
                  maxDay: DateTime(2050),
                  // eventArranger: SideEventArranger(),
                  onEventTap: (allEvents, date) {
                    final event = box.get(allEvents.first.event);

                    if (event != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditEventScreen(event: event),
                        ),
                      );
                    }
                  },
                  headerStyle:
                      HeaderStyle(headerTextStyle: FontsDaily.bigTitle),
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
