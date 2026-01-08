import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/root.dart';

/// Helper class to wrap a Stream and make it listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners(); // initial notify
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Main app router with persistent login and auth guards
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),
  routes: [
    // Root route: decides where to go based on login status
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        return user != null ? '/root' : '/login';
      },
    ),

    // Login page
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        return user != null ? '/root' : null; // redirect if already logged in
      },
    ),

    // Signup page
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        return user != null ? '/root' : null; // redirect if already logged in
      },
    ),

    // Home page (Root)
    GoRoute(
      path: '/root',
      builder: (context, state) => const Root(),
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        return user == null ? '/login' : null; // protect /home
      },
    ),
  ],
);
