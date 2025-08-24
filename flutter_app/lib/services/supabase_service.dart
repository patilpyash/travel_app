import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: true,
        persistSession: true,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
