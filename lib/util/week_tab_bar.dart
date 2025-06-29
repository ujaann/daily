import 'package:calendar_view/calendar_view.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:flutter/material.dart';

List<DateTime> getCurrentWeekDates(DateTime today) {
  final sunday = today.firstDayOfWeek(start: WeekDays.sunday);
  final saturday = today.lastDayOfWeek(start: WeekDays.sunday);
  return [
    sunday,
    sunday.add(Duration(days: 1)),
    sunday.add(Duration(days: 2)),
    sunday.add(Duration(days: 3)),
    sunday.add(Duration(days: 4)),
    sunday.add(Duration(days: 5)),
    saturday
  ];
}

class WeekTabBar extends StatefulWidget {
  final void Function(DateTime selectedDate) onDateSelected;

  const WeekTabBar({super.key, required this.onDateSelected});

  @override
  State<WeekTabBar> createState() => _WeekTabBarState();
}

class _WeekTabBarState extends State<WeekTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DateTime> _weekDates;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _weekDates = getCurrentWeekDates(today);
    final initialIndex = _weekDates.indexWhere((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day);

    _tabController = TabController(
      length: 7,
      vsync: this,
      initialIndex: initialIndex >= 0 ? initialIndex : 0,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onDateSelected(_weekDates[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          return SizedBox(
            width: double.infinity,
            child: TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(),
              labelColor: ColorsDaily.purple,
              unselectedLabelColor: ColorsDaily.darkgray,
              tabs: _weekDates.asMap().entries.map((date) {
                final weekday =
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.value.weekday - 1];
                final isSelected = _tabController.index == date.key;
                return SizedBox(
                  height: 70,
                  child: Tab(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(weekday),
                        CircleAvatar(
                          radius: 16, // Adjust the size of the circle
                          backgroundColor: isSelected
                              ? ColorsDaily.green
                              : Colors.transparent,
                          child: Text(
                            '${date.value.day}',
                            style: FontsDaily.bigTitle.copyWith(
                              color:
                                  isSelected ? Colors.white : ColorsDaily.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}
