import 'package:get/get.dart';
import '../data/models/fluid_model.dart';
import '../data/services/storage_service.dart';
import '../data/services/notification_service.dart';

class FluidController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final NotificationService _notificationService = Get.find<NotificationService>();

  // Observables
  final RxList<FluidIntake> todayIntakes = <FluidIntake>[].obs;
  final RxDouble totalIntakeToday = 0.0.obs;
  final Rx<FluidSettings?> settings = Rx<FluidSettings?>(null);
  final RxBool isLoading = false.obs;
  final RxDouble progressPercentage = 0.0.obs;

  // Form variables
  final RxDouble dailyGoal = 2000.0.obs;
  final RxInt reminderInterval = 60.obs;
  final RxBool reminderEnabled = true.obs;
  final Rx<DateTime> startTime = DateTime(2024, 1, 1, 8, 0).obs;
  final Rx<DateTime> endTime = DateTime(2024, 1, 1, 22, 0).obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    isLoading.value = true;
    
    // Load settings
    final savedSettings = _storageService.getFluidSettings();
    if (savedSettings != null) {
      settings.value = savedSettings;
      dailyGoal.value = savedSettings.dailyGoal;
      reminderInterval.value = savedSettings.reminderInterval;
      reminderEnabled.value = savedSettings.reminderEnabled;
      startTime.value = savedSettings.startTime;
      endTime.value = savedSettings.endTime;
    } else {
      // Set default settings
      settings.value = FluidSettings(
        startTime: startTime.value,
        endTime: endTime.value,
      );
    }
    
    // Load today's intake
    await _loadTodayIntake();
    
    // Schedule reminders if enabled
    if (reminderEnabled.value) {
      await _scheduleFluidReminders();
    }
    
    isLoading.value = false;
  }

  Future<void> _loadTodayIntake() async {
    final intakes = await _storageService.getTodayFluidIntake();
    todayIntakes.assignAll(intakes);
    _calculateTotalIntake();
  }

  void _calculateTotalIntake() {
    totalIntakeToday.value = todayIntakes.fold(0.0, (sum, intake) => sum + intake.amount);
    progressPercentage.value = (totalIntakeToday.value / dailyGoal.value * 100).clamp(0.0, 100.0);
  }

  Future<void> addFluidIntake(double amount, {String type = 'water'}) async {
    final intake = FluidIntake(
      id: 0, // Will be set by database
      date: DateTime.now(),
      amount: amount,
      type: type,
    );

    await _storageService.saveFluidIntake(intake);
    await _loadTodayIntake();

    Get.snackbar(
      'Added! 💧',
      '${amount.toInt()}ml $type added to your daily intake',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    // Check if goal is reached
    if (totalIntakeToday.value >= dailyGoal.value && 
        totalIntakeToday.value - amount < dailyGoal.value) {
      Get.snackbar(
        'Goal Achieved! 🎉',
        'Congratulations! You\'ve reached your daily hydration goal!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> updateSettings() async {
    final newSettings = FluidSettings(
      dailyGoal: dailyGoal.value,
      reminderInterval: reminderInterval.value,
      reminderEnabled: reminderEnabled.value,
      startTime: startTime.value,
      endTime: endTime.value,
    );

    _storageService.saveFluidSettings(newSettings);
    settings.value = newSettings;
    _calculateTotalIntake();

    // Reschedule reminders
    if (reminderEnabled.value) {
      await _scheduleFluidReminders();
    } else {
      // Cancel existing reminders
      for (int i = 2000; i < 2020; i++) {
        await _notificationService.cancelNotification(i);
      }
    }

    Get.snackbar(
      'Settings Updated',
      'Your fluid tracking settings have been saved',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _scheduleFluidReminders() async {
    // Cancel existing reminders
    for (int i = 2000; i < 2020; i++) {
      await _notificationService.cancelNotification(i);
    }

    if (!reminderEnabled.value) return;

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, startTime.value.hour, startTime.value.minute);
    final end = DateTime(now.year, now.month, now.day, endTime.value.hour, endTime.value.minute);

    DateTime current = start;
    int notificationId = 2000;

    while (current.isBefore(end) && notificationId < 2020) {
      if (current.isAfter(now)) {
        await _notificationService.scheduleFluidReminder(
          id: notificationId,
          scheduledTime: current,
          message: 'Time to hydrate! Drink some water to stay healthy 💧',
        );
      }
      
      current = current.add(Duration(minutes: reminderInterval.value));
      notificationId++;
    }
  }

  List<Map<String, dynamic>> getQuickAddOptions() {
    return [
      {'amount': 250.0, 'label': '250ml', 'icon': '🥛'},
      {'amount': 500.0, 'label': '500ml', 'icon': '🧴'},
      {'amount': 750.0, 'label': '750ml', 'icon': '🍶'},
      {'amount': 1000.0, 'label': '1L', 'icon': '💧'},
    ];
  }

  String getMotivationalMessage() {
    final percentage = progressPercentage.value;
    
    if (percentage >= 100) {
      return "Excellent! You've crushed your hydration goal! 🎉";
    } else if (percentage >= 75) {
      return "Almost there! Just a little more to go! 💪";
    } else if (percentage >= 50) {
      return "Great progress! Keep it up! 👍";
    } else if (percentage >= 25) {
      return "Good start! Stay consistent! 🌟";
    } else {
      return "Let's get hydrated! Your body will thank you! 💧";
    }
  }

  void setDailyGoal(double goal) {
    dailyGoal.value = goal;
    _calculateTotalIntake();
  }

  void setReminderInterval(int interval) {
    reminderInterval.value = interval;
  }

  void toggleReminder(bool enabled) {
    reminderEnabled.value = enabled;
  }

  void setReminderTimes(DateTime start, DateTime end) {
    startTime.value = start;
    endTime.value = end;
  }
}