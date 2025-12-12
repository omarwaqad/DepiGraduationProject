import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Make it a getter that's called when needed, not at initialization
  static SupabaseClient get instance => Supabase.instance.client;
}
