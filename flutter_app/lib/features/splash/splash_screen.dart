import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/supabase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await SupabaseService.init();
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FlutterLogo(size: 96),
            const SizedBox(height: 16),
            Text('Loading…', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
