import 'package:flutter/material.dart'; 

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'controllers/main_controller.dart';
import 'i18n/strings.g.dart';
import 'pages/castom_page/castom_page.dart';
import 'pages/calendar_page/calendar_page.dart';
import 'pages/profile_page/profile_page.dart';
import 'pages/profile_page/subpages/settings_subpage.dart';

final MainController _controller = Get.find();
final _rootNavigationKey = GlobalKey<NavigatorState>();
final _shellNavigationKey = GlobalKey<NavigatorState>();

class _destination {
  late String path;
  late String name;
  late Icon icon;
  late Icon selectedIcon;
}

final _destinations = <_destination>[
  _destination()
    ..path = '/calendar'
    ..name = t.navbar.calendar
    ..icon = const Icon(Icons.calendar_month_outlined)
    ..selectedIcon = const Icon(Icons.calendar_month),
  _destination()
    ..path = '/custom'
    ..name = t.navbar.castompage
    ..icon = const Icon(Icons.library_books_outlined)
    ..selectedIcon = const Icon(Icons.library_books),
  _destination()
    ..path = '/profile'
    ..name = t.navbar.profile
    ..icon = const Icon(Icons.person_2_outlined)
    ..selectedIcon = const Icon(Icons.person_2),
];

final router = GoRouter(
  navigatorKey: _rootNavigationKey,
  initialLocation: '/calendar',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigationKey,
      // ShellRoute показывает UI-оболочку вокруг соответствующего дочернего маршрута
      builder: (context, state, child) {
        // UI-оболочка - это Scaffold с NavigationBar
        return Obx(() => Scaffold(
              bottomNavigationBar: NavigationBar(
                selectedIndex: _controller.page(),
                onDestinationSelected: (index) {
                  _controller.page(index);
                  return context.go(
                    _destinations[index].path,
                  );
                },
                destinations: _destinations
                    .map((e) => NavigationDestination(
                        icon: e.icon,
                        selectedIcon: e.selectedIcon,
                        label: e.name))
                    .toList(),
              ),
              body: child,
            ));
      },
      // Вложенные маршруты для каждой вкладки
      routes: [
        GoRoute(
          path: _destinations[0].path,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const CalendarPage(),
          ),
          routes: const [],
        ),
        GoRoute(
          path: _destinations[1].path,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const CastomPage(),
          ),
          routes: const [],
        ),
        GoRoute(
          path: _destinations[2].path,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const ProfilePage(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigationKey,
              path: 'settings',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: const SettingsSubpage(),
              ),
              routes: const [],
            ),
          ],
        ),
      ],
    ),
  ],
);
