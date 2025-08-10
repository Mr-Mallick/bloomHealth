import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'app/data/services/analytics_service.dart';
import 'app/routes/app_pages.dart';
import 'app/ui/theme/app_theme.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/services/notification_service.dart';
import 'app/utils/firebase_option.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize Analytics Service
    Get.put(AnalyticsService(), permanent: true);
    
    
  } catch (e) {
    // debugPrint('❌ Firebase initialization error: $e');
  }
  
  // Initialize timezone data with automatic detection
  await _initializeTimeZone();
  
  // Initialize storage
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => NotificationService().init());
  
  runApp(MyApp());
}

/// Initialize timezone automatically using system timezone
Future<void> _initializeTimeZone() async {
  try {
    // Initialize timezone database
    tz.initializeTimeZones();
    
    // Get system timezone offset
    final DateTime now = DateTime.now();
    final Duration offset = now.timeZoneOffset;
    
    // Try to determine timezone based on offset and system locale
    String detectedTimezone = _getTimezoneFromOffset(offset);
    
    // debugPrint('🌍 Detected system timezone offset: ${offset.inHours} hours');
    // debugPrint('🌍 Using timezone: $detectedTimezone');
    
    // Set the local timezone
    tz.setLocalLocation(tz.getLocation(detectedTimezone));
    // debugPrint('✅ Timezone initialized successfully: ${tz.local.name}');
    
  } catch (e) {
    // debugPrint('⚠️ Error setting timezone: $e');
    // Fallback to UTC
    tz.setLocalLocation(tz.getLocation('UTC'));
    // debugPrint('🌍 Fallback to UTC timezone');
  }
}

/// Map timezone offset to common timezone locations
String _getTimezoneFromOffset(Duration offset) {
  final int offsetHours = offset.inHours;
  
  // Map common offsets to timezone locations
  switch (offsetHours) {
    case -8:
      return 'America/Los_Angeles'; // PST
    case -7:
      return 'America/Denver'; // MST
    case -6:
      return 'America/Chicago'; // CST
    case -5:
      return 'America/New_York'; // EST
    case 0:
      return 'Europe/London'; // GMT
    case 1:
      return 'Europe/Paris'; // CET
    case 2:
      return 'Europe/Athens'; // EET
    case 3:
      return 'Europe/Moscow'; // MSK
    case 4:
      return 'Asia/Dubai'; // GST
    case 5:
      return 'Asia/Karachi'; // PKT
    case 5.5:
      return 'Asia/Kolkata'; // IST
    case 6:
      return 'Asia/Dhaka'; // BST
    case 7:
      return 'Asia/Bangkok'; // ICT
    case 8:
      return 'Asia/Singapore'; // SGT
    case 9:
      return 'Asia/Tokyo'; // JST
    case 10:
      return 'Australia/Sydney'; // AEST
    case 11:
      return 'Pacific/Auckland'; // NZST
    case 12:
      return 'Pacific/Fiji'; // FJT
    default:
      // For any other offset, use UTC
      return 'UTC';
  }
}


class MyApp extends StatelessWidget {

  // Firebase Analytics Observer for automatic screen tracking
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = 
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bloom Health',
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}