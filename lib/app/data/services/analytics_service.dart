import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class AnalyticsService extends GetxService {
  static AnalyticsService get to => Get.find();
  
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  FirebaseAnalytics get analytics => _analytics;
  
  @override
  void onInit() {
    super.onInit();
    _initializeAnalytics();
  }
  
  void _initializeAnalytics() {
    // Enable analytics collection
    _analytics.setAnalyticsCollectionEnabled(true);
    
    // Log app open event
    logAppOpen();
    
    print('✅ Firebase Analytics initialized');
  }
  
  // Track app installations and opens
  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }
  
  // Track screen views
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
  
  // Track user engagement
  Future<void> logUserEngagement() async {
    await _analytics.logEvent(
      name: 'user_engagement',
      parameters: {
        'engagement_time_msec': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  // Track app usage patterns
  Future<void> logAppUsage(String feature) async {
    await _analytics.logEvent(
      name: 'feature_usage',
      parameters: {
        'feature_name': feature,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  // Track session length
  Future<void> logSessionStart() async {
    await _analytics.logEvent(
      name: 'session_start',
      parameters: {
        'session_id': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }
  
  Future<void> logSessionEnd() async {
    await _analytics.logEvent(
      name: 'session_end',
      parameters: {
        'session_id': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }
}