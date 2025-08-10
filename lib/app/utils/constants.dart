class AppConstants {
  // App Info
  static const String appName = 'Fertility Tracker';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String isFirstTimeKey = 'is_first_time';
  static const String fluidSettingsKey = 'fluid_settings';
  static const String userPreferencesKey = 'user_preferences';
  
  // Default Values
  static const int defaultCycleLength = 28;
  static const double defaultDailyFluidGoal = 2000.0;
  static const int defaultFluidReminderInterval = 60;
  
  // Notification IDs
  static const int periodReminderBaseId = 1000;
  static const int fluidReminderBaseId = 2000;
  static const int medicineReminderBaseId = 3000;
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Validation
  static const int minCycleLength = 21;
  static const int maxCycleLength = 40;
  static const double minFluidGoal = 1000.0;
  static const double maxFluidGoal = 4000.0;
}