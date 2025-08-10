// import 'package:get/get.dart';
// import 'package:timezone/timezone.dart' as tz;

// class TimezoneService extends GetxService {
//   static TimezoneService get to => Get.find();
  
//   String _currentTimezone = 'UTC';
  
//   String get currentTimezone => _currentTimezone;
//   tz.Location get currentLocation => tz.getLocation(_currentTimezone);
  
//   Future<TimezoneService> init() async {
//     await _detectAndSetTimezone();
//     return this;
//   }
  
//   Future<void> _detectAndSetTimezone() async {
//     try {
//       // Get device timezone
//       final String deviceTimeZone = await FlutterNativeTimezone.getLocalTimezone();
//       _currentTimezone = deviceTimeZone;
      
//       // Set the timezone
//       tz.setLocalLocation(tz.getLocation(deviceTimeZone));
      
//       print('🌍 Timezone Service: Detected and set timezone to $_currentTimezone');
      
//     } catch (e) {
//       print('⚠️ Timezone Service: Error detecting timezone: $e');
//       // Fallback to UTC
//       _currentTimezone = 'UTC';
//       tz.setLocalLocation(tz.getLocation('UTC'));
//     }
//   }
  
//   /// Convert DateTime to TZDateTime using current timezone
//   tz.TZDateTime convertToTZDateTime(DateTime dateTime) {
//     try {
//       return tz.TZDateTime.from(dateTime, currentLocation);
//     } catch (e) {
//       print('❌ Error converting to TZDateTime: $e');
//       // Fallback to UTC
//       return tz.TZDateTime.from(dateTime, tz.getLocation('UTC'));
//     }
//   }
  
//   /// Check if a datetime is in the future
//   bool isFutureDateTime(DateTime dateTime) {
//     final now = tz.TZDateTime.now(currentLocation);
//     final tzDateTime = convertToTZDateTime(dateTime);
//     return tzDateTime.isAfter(now);
//   }
  
//   /// Get current time in user's timezone
//   tz.TZDateTime getCurrentTime() {
//     return tz.TZDateTime.now(currentLocation);
//   }
  
//   /// Get timezone offset string (e.g., "+05:30")
//   String getTimezoneOffset() {
//     final now = getCurrentTime();
//     final offset = now.timeZoneOffset;
//     final hours = offset.inHours;
//     final minutes = offset.inMinutes % 60;
//     final sign = offset.isNegative ? '-' : '+';
//     return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.abs().toString().padLeft(2, '0')}';
//   }
// }