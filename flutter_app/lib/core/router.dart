import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_page.dart';
import '../features/auth/sign_in_page.dart';
import '../features/auth/sign_up_page.dart';
import '../features/profile/profile_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    GoRoute(path: '/sign-in', builder: (_, __) => const SignInPage()),
    GoRoute(path: '/sign-up', builder: (_, __) => const SignUpPage()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
      redirect: (context, state) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session == null) return '/sign-in';
        return null;
      },
    ),
  ],
);
