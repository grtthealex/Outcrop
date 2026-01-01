import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outcrop/pages/signup.dart';

import 'pages/login.dart';
import 'pages/home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    GoRoute(path: '/signup', builder: (context, state) => SignupPage()),
  ],
);
