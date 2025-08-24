import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionListener extends StatefulWidget {
  final Widget child;
  const SessionListener({super.key, required this.child});
  @override
  State<SessionListener> createState() => _SessionListenerState();
}

class _SessionListenerState extends State<SessionListener> {
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        if (mounted) context.go('/profile');
      } else if (event == AuthChangeEvent.signedOut) {
        if (mounted) context.go('/home');
      }
    });
  }
  @override
  Widget build(BuildContext context) => widget.child;
}
