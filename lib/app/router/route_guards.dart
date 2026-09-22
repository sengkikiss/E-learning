import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/user.dart';
import 'route_names.dart';

class RouteGuards {
  RouteGuards._();

  static String? guard({
    required BuildContext context,
    required GoRouterState state,
    required User? currentUser,
    required bool isLoading,
  }) {
    if (isLoading) return null;

    final location = state.uri.path;
    final isLoggingIn = location == RouteNames.login ||
        location == RouteNames.register ||
        location == RouteNames.forgotPassword ||
        location == RouteNames.splash ||
        location == RouteNames.onboarding;

    // 1. If not authenticated and trying to access protected paths
    if (currentUser == null) {
      if (!isLoggingIn) {
        return RouteNames.login;
      }
      return null;
    }

    // 2. If authenticated and attempting to visit login/register screens
    if (isLoggingIn && location != RouteNames.splash) {
      return RouteNames.home;
    }

    // 3. Role-based guards
    if (location.startsWith('/admin') && !currentUser.isAdmin) {
      return RouteNames.home;
    }

    if (location.startsWith('/instructor') && !currentUser.isInstructor) {
      return RouteNames.home;
    }

    return null;
  }
}
