import 'package:flutter/material.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'core/session_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'John Doe Feed',
      theme: AppTheme.light(),
      routerConfig: router,
      builder: (context, child) => SessionListener(child: child ?? const SizedBox.shrink()),
    );
  }
}
