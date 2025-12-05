import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://nrmswovzdviwcayztnom.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ybXN3b3Z6ZHZpd2NheXp0bm9tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4Nzk3MzksImV4cCI6MjA4MDQ1NTczOX0.lbOzZTTj0-hj6q8IEGPSXvA7WacFJUg-A3_iIT4etbM';

  static Future<void> init() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }
}
