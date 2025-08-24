class AppConstants {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'local-anon');
}
