// lib/core/network/supabase_config.dart
// Supabase project credentials.
// The Supabase Flutter SDK uses these to initialize the client which then
// handles all HTTP calls (auth + PostgREST), JWT storage, and auto-refresh.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://zwgqbaenzhvnectougef.supabase.co';
  static const String anonKey =
      'sb_publishable_xo56YZNVM5XBuBRPSSTVYg_t-CIU0u3';
}
