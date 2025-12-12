import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides a single place to access the Supabase client.
class SupabaseClientProvider {
  SupabaseClientProvider({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  SupabaseClient get client => _client;
}
