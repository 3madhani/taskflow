// Hive box names — for offline cache + theme preference only.
// NOTE: JWT is managed automatically by supabase_flutter (flutter_secure_storage).
// There is NO auth_box — Supabase SDK owns the token lifecycle.
class HiveBoxes {
  HiveBoxes._();

  static const String projects = 'projects_box'; // offline-cached ProjectModel list
  static const String tasks = 'tasks_box'; // offline-cached TaskModel list
  static const String settings = 'settings_box'; // theme preference
}

class HiveKeys {
  HiveKeys._();

  // NOTE: No jwt_token key — Supabase manages the token lifecycle.
  static const String currentUser = 'current_user'; // cached UserModel
  static const String themeMode = 'theme_mode'; // 'light' | 'dark'
}
