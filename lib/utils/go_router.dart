import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tube_scriptor_ai/landing/splash_screen.dart';
import 'package:tube_scriptor_ai/screens/home.dart';
import 'package:tube_scriptor_ai/screens/scriptor.dart';
import 'package:tube_scriptor_ai/screens/settings_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GoRouter basicRoutes = GoRouter(
  routes: appRoutesList,
  initialLocation: "/",
  debugLogDiagnostics: true,
  navigatorKey: navigatorKey,
  errorBuilder: (context, state) => Center(
    child: Container(
      color: Colors.white,
      child: Text(state.error.toString()),
    ),
  ),
);
List<RouteBase> appRoutesList = [
  GoRoute(
    path: "/",
    name: "splash",
    builder: (context, state) => SplashScreen(),
  ),
  GoRoute(
    path: "/home",
    name: "home page",
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: "/scriptor",
    name: "scriptor page",
    builder: (context, state) => const ScriptorPage(),
  ),
  GoRoute(
    path: "/settings",
    name: "settings page",
    builder: (context, state) => const SettingsPage(),
  ),
];
