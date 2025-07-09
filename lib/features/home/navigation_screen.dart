import 'package:daily/auth/auth_service.dart';
import 'package:daily/features/event/event_screen.dart';
import 'package:daily/features/event/new_event_screen.dart';
import 'package:daily/features/expense/view/expense_screen.dart';
import 'package:daily/features/expense/view/new_expense_screen.dart';
import 'package:daily/features/graphs/graphs_screen.dart';
import 'package:daily/features/search/search_screen.dart';
import 'package:daily/features/user/login_signup_screen.dart';
import 'package:daily/notification/notification_service.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:daily/util/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

final _currentPageProvider = StateProvider<int>((ref) {
  return 0;
});
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

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
        title: Text(["Events", "Expenses", "Graphs"][currentIndex]),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  )),
              icon: Icon(Icons.search)),
          PopupMenuButton<int>(
            icon: Icon(Icons.settings),
            onSelected: (value) async {
              switch (value) {
                case 0: // Toggle Notifications
                  final enabled = ref.read(notificationsEnabledProvider);
                  if (!enabled) {
                    ref.read(notificationsEnabledProvider.notifier).state =
                        true;
                    return;
                  }
                  await showConfirmationDialog(
                    context: context,
                    title: "This action will stop all notifications?",
                    content: "Do you want to continue?",
                  ).then((confirmed) async {
                    if (confirmed != null && confirmed) {
                      ref.read(notificationsEnabledProvider.notifier).state =
                          !enabled;
                      await NotifyService().cancellNotifications();
                    }
                  });
                  break;
                case 1: // Logout
                  await showConfirmationDialog(
                    context: context,
                    title: "Do you want to logout?",
                  ).then((confirmed) async {
                    if (confirmed != null && confirmed) {
                      await NotifyService().cancellNotifications();
                      await ref.read(authServiceProvider.notifier).clear();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginSignupScreen(),
                          ),
                        );
                      }
                    }
                  });
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      ref.watch(notificationsEnabledProvider)
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: 8),
                    Text(ref.watch(notificationsEnabledProvider)
                        ? "Disable Notifications"
                        : "Enable Notifications"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.logout,
                        color: Theme.of(context).iconTheme.color),
                    SizedBox(width: 8),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
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
            icon: Icon(Icons.pie_chart),
            label: "Graphs",
            selectedIcon:
                Icon(Icons.pie_chart_outline, color: ColorsDaily.white),
          ),
        ],
      ),
      body: [
        EventScreen(),
        ExpenseScreen(),
        GraphsScreen(),
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
                        builder: (context) => NewExpenseScreen(),
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
