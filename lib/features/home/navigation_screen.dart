import 'package:daily/features/event/event_screen.dart';
import 'package:daily/features/event/new_event_screen.dart';
import 'package:daily/features/expense/view/expense_screen.dart';
import 'package:daily/features/setting/setting_screen.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/view/floating_new_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

final _currentPageProvider = StateProvider<int>((ref) {
  return 0;
});

class NavigationScreen extends ConsumerWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentIndex = ref.watch(_currentPageProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'assets/Logo.svg',
            semanticsLabel: "DAily Logo",
          ),
        ),
        title: Text(["Events", "Expenses", "Settings"][currentIndex]),
        actions: [
          IconButton(onPressed: null, icon: Icon(Icons.search)),
          IconButton(
              onPressed: null, icon: Icon(Icons.account_circle_outlined)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) =>
            ref.read(_currentPageProvider.notifier).state = value,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: "Event",
            selectedIcon: Icon(Icons.calendar_today, color: ColorsDaily.white),
          ),
          NavigationDestination(
            icon: Icon(Icons.monetization_on_outlined),
            label: "Expense",
            selectedIcon:
                Icon(Icons.monetization_on_outlined, color: ColorsDaily.white),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Settings",
            selectedIcon: Icon(Icons.settings, color: ColorsDaily.white),
          ),
        ],
      ),
      body: [
        EventScreen(),
        ExpenseScreen(),
        SettingScreen(),
      ][currentIndex],
      floatingActionButton: Visibility(
        visible: currentIndex != 2,
        child: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 36,
              color: Colors.white,
            ),
            onPressed: () {
              switch (currentIndex) {
                case 0:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewEventScreen(),
                      ));
                  break;
                case 1:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FloatingNewPage(text: "Expense"),
                      ));
                  break;

                default:
                  break;
              }
            }),
      ),
    );
  }
}
