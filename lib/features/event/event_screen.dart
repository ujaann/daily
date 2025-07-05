import 'package:calendar_view/calendar_view.dart';
import 'package:daily/entity/event.dart';
import 'package:daily/features/event/data/event_repo.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/week_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
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
    final controller = ref.watch(eventControllerProvider);
    final box = ref.watch(eventRepoProvider).box;
    final time = TimeOfDay.now();

    return CalendarControllerProvider(
      controller: controller,
      child: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<EventEntity> box, _) {
          final events = box.values.where((e) => e.userId == "Ujan").toList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.removeWhere((_) => true);
            controller.addAll(events
                .map(
                  (e) => e.eventData.copyWith(color: ColorsDaily.cream70),
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
                  scrollOffset: (time.hour * 60 + time.minute) * 1.25 - 20,
                  heightPerMinute: 1.25,
                  minDay: DateTime(2024),
                  maxDay: DateTime(2050),
                  eventArranger: SideEventArranger(),
                  onEventTap: (events, date) => print(events),
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
