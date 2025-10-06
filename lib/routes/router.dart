import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:realneers_reports/features/auth/presentation/screens/auth_screens.dart';
import 'route_paths.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Routes.login,
  routes: [
    GoRoute(
      path: Routes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);